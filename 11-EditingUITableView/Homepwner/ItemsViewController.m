//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Marjan Hratson on 9/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "PosessionStore.h"

// I was wondering where is the view for this controller
// Turns out that UITableViewController gets view automatically
// as from UITableViewController's docs:

// The UITableViewController class creates a controller object that manages a table view.
// If a nib file is specified via the initWithNibName:bundle: method (which is declared by the superclass UIViewController), 
// UITableViewController loads the table view archived in the nib file. 
// Otherwise, it creates an unconfigured UITableView object with the correct dimensions and autoresize mask. 
// You can access this view through the tableView property.

@implementation ItemsViewController

- (id)init {

    self = [super initWithStyle:UITableViewStyleGrouped];

    if (self) {
        for (int i = 0; i < 15; i++) {
            [[PosessionStore defaultStore] createPosession];
        }
    }

    return self;
}

// this is required in order to be consistent
// otherwise UITableViewStyleGrouped style 
// may be lost in case non-overriden initWithStyle 
// gets called
-(id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

#pragma mark headerView

-(UIView *)headerView {
    if(!headerView) {
        //Load NSBundle
        //NOTE: owner set to self
        //As I understand 
        // 1) IB want's to know about File's Owner interface to be able connect object in Design TIme
        // 2) in Run time File's Owner is set with owner:self that's why it's require  
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}

-(IBAction)toggleEditMode:(id)sender {
    [sender setTitle:([self isEditing] ? @"Edit" : @"Done") forState:UIControlStateNormal];
    [self setEditing:![self isEditing] animated:YES];
}

 -(IBAction)addNewPosession:(id)sender {
    [[PosessionStore defaultStore] createPosession];
    
    [[self tableView] reloadData];     
}

#pragma mark UITableViewDataSource protocol
// Deletion
-(void)      tableView:(UITableView *)tableView 
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
     forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PosessionStore *ps = [PosessionStore defaultStore];
        [ps removePosession:[ps.posessions objectAtIndex:[indexPath row]]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

-(void)     tableView:(UITableView *)tableView 
   moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
          toIndexPath:(NSIndexPath *)destinationIndexPath 
{
    [[PosessionStore defaultStore] 
        moveAtIndex:[sourceIndexPath row] 
            toIndex:[destinationIndexPath row]];
}

// Header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[self headerView] bounds].size.height;
}

//Sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [NSArray arrayWithObjects:@"Radios", @"Phones", @"Cartones", nil];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[NSArray arrayWithObjects:@"Radios", @"Phones", @"Cartones", nil] objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[PosessionStore.defaultStore posessions] count] / [self numberOfSectionsInTableView:tableView];
}

// Cells
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Check for reusable cell from pull first
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    
    if (!cell) { // otherwise create
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:@"UITableViewCell"];
    }
    // 5 is number of rows in section
    int idx = [indexPath section] * 5 + [indexPath row];
    
    Posession *p = [[[PosessionStore defaultStore] posessions] objectAtIndex:idx];
    
    NSString *s = [NSString stringWithFormat:@"%d", idx];
    
    [[cell textLabel] setText:[p description]];
    [[cell detailTextLabel] setText:s];  
    
    return cell;
}
@end
