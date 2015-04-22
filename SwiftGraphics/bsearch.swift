//
//  bsearch.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 4/22/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

public enum Order {
    case ascending
    case equal
    case descending
}

public func compare <T:Comparable> (lhs:T, rhs:T) -> Order {
    return lhs == rhs ? .equal : (lhs < rhs ? .ascending : .descending)
}

/**
 Binary search a `CollectionType` (`Array`, etc) whose elements are in a sorted order.

 :param: domain  A *sorted* collection
 :param: value   Value to search for within collection.
 :param: compare Closure that takes two objects and returns an `Order` enum

 :returns: Index to value if it exists in collection domain else return nil
 */
public func bsearch <C: CollectionType where C.Index : RandomAccessIndexType> (domain: C, value:C.Generator.Element, compare:(C.Generator.Element, C.Generator.Element) -> Order) -> C.Index? {
    return bsearch(domain) {
        return compare($0, value)
    }
}

/**
 Binary search a `CollectionType` (`Array`, etc) whose elements are in a sorted order.

 :param: domain  A *sorted* collection
 :param: value   Value to search for within collection.
 :param: compare Closure that takes two objects and returns an `Order` enum

 :returns: A tuple containing true, and an index to the element if the element is found. Or false, and an index to the nearest element if the value is not found.
 */
public func bsearch_closest <C: CollectionType where C.Index : RandomAccessIndexType> (domain: C, value:C.Generator.Element, compare:(C.Generator.Element, C.Generator.Element) -> Order) -> (Bool, C.Index) {
    return bsearch_closest(domain) {
        return compare($0, value)
    }
}

public func bsearch <C: CollectionType where C.Index : RandomAccessIndexType> (domain: C, compare: (C.Generator.Element) -> Order) -> C.Index? {
    let (found, index) = bsearch_closest(domain, compare)
    return found ? index : nil
}

public func bsearch_closest <C: CollectionType where C.Index : RandomAccessIndexType> (domain: C, compare: (C.Generator.Element) -> Order) -> (Bool, C.Index) {

    func midpoint(lhs:C.Index, rhs:C.Index) -> C.Index {
        let midDistance = (domain.startIndex.distanceTo(lhs) + domain.startIndex.distanceTo(rhs)) / 2
        return domain.startIndex.advancedBy(midDistance)
    }

    var imin = domain.startIndex
    var imax = domain.endIndex.advancedBy(-1)

    // continue searching while [imin,imax] is not empty
    var imid = domain.startIndex
    while imax >= imin {
        // calculate the midpoint for roughly equal partition
        imid = midpoint(imin, imax)
        if compare(domain[imid]) == .equal {
            // key found at index imid
            return (true, imid)
        }
        // determine which subarray to search
        else if compare(domain[imid]) == .ascending {
            // change min index to search upper subarray
            imin = imid + 1
        }
        else {
            // change max index to search lower subarray
            imax = imid - 1;
        }
    }
    // key was not found
    return (false, imid)
}

//let test = [0,1,10,100]
//println(bsearch_closest(test, { compare($0, 90) }))
//println(bsearch(test, { compare($0, -100) }))
//println(bsearch(test, { compare($0, 0) }))
//println(bsearch(test, { compare($0, 1) }))
//println(bsearch(test, { compare($0, 5) }))
//println(bsearch(test, { compare($0, 10) }))
//println(bsearch(test, { compare($0, 100) }))
//println(bsearch(test, { compare($0, 1000) }))
//println(bsearch(test, 0, compare))
//println(bsearch(test, 1, compare))
//println(bsearch(test, 10, compare))
//println(bsearch(test, 100, compare))
//println(bsearch(test, 1000, compare))
