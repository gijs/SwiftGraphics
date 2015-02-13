//
//  Model.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/1/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

import SwiftGraphics

// TODO: Replaces Geometry
protocol Frameable {
    var frame:CGRect { get }
}


class Model: NSObject {
    @objc var objects:[Thing] = []
    var selectedObjectIndices:NSMutableIndexSet = NSMutableIndexSet()
    var selectedObjects:[Thing] {
        get {
            var objects:[Thing] = []
            selectedObjectIndices.with(maxCount: 512) {
                for N in $0 {
                    objects.append(self.objects[N])
                }
            }
            return objects
        }
    }

    override init() {
    }

    func hitTest(location:CGPoint) -> (Int, Thing)? {
        for (index, thing) in enumerate(objects) {
            if thing.contains(location) {
                return (index, thing)
            }
        }
        return nil
    }


    func objectSelected(thing:Thing) -> Bool {
        let index = find(objects, thing)
        return selectedObjectIndices.containsIndex(index!)
    }

    func selectObject(object:Thing) {
        let index = find(objects, object)
        selectedObjectIndices.addIndex(index!)
    }

    func unselectObject(object:Thing) {
        let index = find(objects, object)
        selectedObjectIndices.removeIndex(index!)
    }


    func addObject(object:Thing) {
        self.willChangeValueForKey("objects")
        self.objects.append(object)
        self.didChangeValueForKey("objects")
    }

    func removeObject(object:Thing) {
        self.willChangeValueForKey("objects")
        let index = find(objects, object)
        removeObjectAtIndex(index!)
        self.didChangeValueForKey("objects")
    }

    func removeObjectAtIndex(index:Int) {
        objects.removeAtIndex(index)
        selectedObjectIndices.removeIndex(index)
        selectedObjectIndices.shiftIndexesStartingAtIndex(index + 1, by: -1)
    }

    func removeObjectsAtIndices(indices:NSIndexSet) {
        var index = indices.lastIndex
        while index != NSNotFound {
            removeObjectAtIndex(index)
            index = indices.indexLessThanIndex(index)
        }
    }
}

