//
//  CoreDataViewControllerTVCDelegate.h
//  eLBee
//
//  Created by Jonathon Hibbard on 11/6/12.
//
// This code is distributed under the terms and conditions of the MIT license.
// Copyright (c) 2013 Integrated Events, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTVCDelegate : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property BOOL hideTableViewWhenEmpty;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// This is wired up via the IB when dragging the outlet from the tableView to the subClass (main view contorller)
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)performFetch;

@end

