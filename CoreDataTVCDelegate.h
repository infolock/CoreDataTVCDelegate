//
//  CoreDataViewControllerTVCDelegate.h
//  eLBee
//
//  Created by Jonathon Hibbard on 11/6/12.
//  Copyright (c) 2012 Integrated Events, LLC. All rights reserved.
//

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

