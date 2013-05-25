//
//  CoreDataViewControllerTVCDelegate.m
//  eLBee
//
//  Created by Jonathon Hibbard on 11/6/12.
//  Copyright (c) 2012 Integrated Events, LLC. All rights reserved.
//

#import "CoreDataTVCDelegate.h"

@interface CoreDataTVCDelegate ()
@property (nonatomic) BOOL beganUpdates;
@property NSUInteger numSections;
@end


@implementation CoreDataTVCDelegate

#pragma mark - Methods

-(void)performFetch {
    
    if(self.fetchedResultsController) {
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];

        if(error) {
            // DO SOMETHING MEANINGFUL HERE!!
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
    }
    
    [self.tableView reloadData];
}

-(void)setFetchedResultsController:(NSFetchedResultsController *)newfrc {

    NSFetchedResultsController *oldfrc = _fetchedResultsController;

    if(![newfrc isEqual:oldfrc]) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }

        if(newfrc) {
            [self performFetch];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Custom Method for Hiding TableView...
-(void)manageTableViewVisibilityUsingNumObjs:(NSUInteger)numObjs {

    if(self.hideTableViewWhenEmpty && self.numSections <= 1) {

        BOOL tableViewShouldBeHidden = (numObjs == 0) ? YES : NO;
        if(self.tableView.hidden != tableViewShouldBeHidden) {
            [self.tableView setHidden:tableViewShouldBeHidden];
        }
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUInteger *totalSections = [[self.fetchedResultsController sections] count];
    self.numSections = totalSections;
    
    return totalSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger numObjs = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];

    [self manageTableViewVisibilityUsingNumObjs:numObjs];
    
    return numObjs;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"eLBeeDefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark REQUIRED Method to Override
// This method is overriden by the subclass that extends CoreDataTVCDelegate
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    abort();
}



#pragma mark - NSFetchedResultsControllerDelegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if(!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if(!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

            default:break;
        }
    }
}



-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

            default:break;
        }
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if(self.beganUpdates) [self.tableView  endUpdates];
}

-(void)endSuspensionOfUpdatesDueToContextChanges {
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

-(void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend {
    if(suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

@end

