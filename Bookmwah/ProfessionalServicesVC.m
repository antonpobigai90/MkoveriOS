//
//  ProfessionalServicesVC.m
//  Bookmwah
//
//  Created by admin on 20/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "ProfessionalServicesVC.h"

@interface ProfessionalServicesVC ()
{
    NSMutableArray *array;
    long tag;
}
@end

@implementation ProfessionalServicesVC
@synthesize tv,sv,viewShadow,tvPopUp,btnInfo,btnServices,btnPortfolio,btnBankDetails,btnRecommendation,svBtn,btnPopup, popUpView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    bPopUp = false;
    
    arrayTVData=[[NSMutableArray alloc]init];
    array = [[NSMutableArray alloc]init];
    arrayPopUp = [[NSMutableArray alloc]initWithObjects:@"",nil];
    
    popUpView.layer.cornerRadius = 7.5;
    popUpView.layer.masksToBounds = YES;
    
    [tv reloadData];
    [viewShadow setHidden:YES];
    
    [self changeButtonColor];
    
    [self call_ProviderDetailsAPI];
    [self call_ServiceCategoryAPI];
    
    UIView* footerView = [[UIView alloc] init];
    [tv setTableFooterView:footerView];
    [tvPopUp setTableFooterView:footerView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:svBtn])
    {
        
        if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    sv.contentSize = CGSizeMake(sv.contentSize.width,sv.contentSize.height+1050);
    svBtn.contentSize = CGSizeMake(svBtn.contentSize.width+btnPortfolio.frame.size.width+btnBankDetails.frame.size.width,svBtn.contentSize.height);

    [svBtn setContentOffset:CGPointMake((btnServices.frame.origin.x), svBtn.frame.size.height) animated:TRUE];
    [tv reloadData];

}

-(void)changeButtonColor
{
    btnServices.layer. backgroundColor =[WebService colorWithHexString:@"00afdf"].CGColor;
    
    [btnServices setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnInfo.layer. backgroundColor =[WebService colorWithHexString:@"eeeeee"].CGColor;
    
    [btnInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btnBankDetails.layer. backgroundColor =[WebService colorWithHexString:@"eeeeee"].CGColor;
    
    [btnBankDetails setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btnPortfolio.layer. backgroundColor =[WebService colorWithHexString:@"eeeeee"].CGColor;
    
    [btnPortfolio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btnRecommendation.layer. backgroundColor =[WebService colorWithHexString:@"eeeeee"].CGColor;
    
    [btnRecommendation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


-(void)load_MBProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Loading...";
    //HUD.detailsLabelText = @"Pdf..";
    HUD.square = YES;
    [self.view addSubview:HUD];
    
}


#pragma mark - call_ServiceCategoryAPI
#pragma mark -

-(void)call_ServiceCategoryAPI{
    
    [HUD show:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [WebService call_API:dict andURL:API_SERVICE_CATEGORY andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        [HUD hide:YES];
        
        if ([@"true" isEqualToString:[response objectForKey:@"status"]]) {
           
            array =[response objectForKey:@"service_category"];
            
            [tvPopUp reloadData];
        }
    }];
}

-(void)call_ProviderDetailsAPI{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

    NSString *pro_id = [NSUD valueForKey:@"pro_id"];
    [dict setValue:pro_id forKey:@"pro_id"];
    [dict setValue:@"2" forKey:@"type"];

    [HUD show:YES];
    
    [WebService call_API:dict andURL:API_PROVIDERS_DETAILS andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        [HUD hide:YES];
        if ([[response objectForKey:@"status"] isEqualToString:@"true"]) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic = [response valueForKey:@"provider_details"];
            arrayTVData = [dic valueForKey:@"services"];
            
            [tv reloadData];
        }else{
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
        
    }];
}
- (IBAction)btnPopUp:(id)sender {
    bPopUp = true;
    [viewShadow setHidden:false];
    [btnPopup setHidden:false];
    
    [tvPopUp reloadData];
}

- (IBAction)btnCancelPopUp:(id)sender {
    bPopUp = false;
    [viewShadow setHidden:true];
    [btnPopup setHidden:true];
}

#pragma mark - TableView Delegate Methods
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (bPopUp) {
        return  array.count;
    } else {
        return  arrayTVData.count;
    }
    
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic ;
    
    NSString *cellIdentifier = @"itemCell ";
    
    ProfessionalServicesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!bPopUp) {
        dic = [arrayTVData objectAtIndex:indexPath.row];
        
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfessionalServicesTVCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblServices.text  = [dic valueForKey:@"s_name"];
        cell.lblCost.text   = [dic valueForKey:@"s_cost"];

        [cell.showSave addTarget:self action:@selector(showupdate:) forControlEvents:UIControlEventTouchDown];
        cell.showSave.tag = indexPath.row;
        [cell.showCancel addTarget:self action:@selector(showcancel:) forControlEvents:UIControlEventTouchDown];
        cell.showCancel.tag = indexPath.row;

        return cell;
        
    } else {
        dic = [array objectAtIndex:indexPath.row];
        
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfessionalServicesPopUpTVCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        NSString *str ;
        str =[dic valueForKey:@"s_cat_name"];
        NSLog(@"name%@",str);
        [cell.showPopUp setTitle:str forState:UIControlStateNormal];
        [cell.showPopUp setTag:indexPath.row];
        
        [cell.showPopUp addTarget:self action:@selector(showpopup:) forControlEvents:UIControlEventTouchDown];
        
        return cell;
        
    }
    
    return  nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tv) {
        return 50;
    } else if (tableView == tvPopUp) {
        return 50;
    }
    return 0;
}
-(void)showpopup:(UIButton *)sender{
    
    NSLog(@"call Show  1");
    tag = [sender tag];
    [viewShadow setHidden:true];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = [array objectAtIndex:tag];
    
    DiscountVC *discountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DiscountVC"];
    discountVC.m_bNew = true;
    discountVC.category = [dic valueForKey:@"s_cat_id"];
    [self presentViewController:discountVC animated:false completion:nil];
}

-(void)showupdate:(id)sender{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    dic = [arrayTVData objectAtIndex:[sender tag]];
    
    DiscountVC *discountVC = [self.storyboard
                              instantiateViewControllerWithIdentifier:@"DiscountVC"];
    
    discountVC.m_bNew = false;
    discountVC.serviceDit = dic;
    [self presentViewController:discountVC animated:false completion:nil];
    
}

-(void)showcancel:(id)sender{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    dic = [arrayTVData objectAtIndex:[sender tag]];
    
    NSString *sid  = [dic valueForKey:@"s_id"];
    
    [self call_REMOVEAPI:sid];
    
}


-(void)call_REMOVEAPI:(NSString *)ServiceID{
    
    [HUD show:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:ServiceID forKey:@"s_id"];
    
    [WebService call_API:dict andURL:API_REMOVE_SERVICE andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        [HUD hide:YES];
        
        NSString *sts = [response objectForKey:@"status"];
        
        if ([sts isEqualToString:@"true"]) {
            
            [tv reloadData];
            
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
        else{
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Services:(id)sender {

//    ProfessionalServicesVC *professionalServicesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfessionalServicesVC"];
//
//    [self.navigationController pushViewController:professionalServicesVC animated:NO];
    //[self presentViewController:professionalServicesVC animated:false completion:nil];
    
}

- (IBAction)Recommendation:(id)sender {
    
    ProfessionalRecommendationVC *professionalRecommendationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfessionalRecommendationVC"];
    
    [self.navigationController pushViewController:professionalRecommendationVC animated:NO];
    
    //[self presentViewController:professionalRecommendationVC animated:false completion:nil];
    
}

- (IBAction)Info:(id)sender {
    
    
    ProfessionalInfoVC *professionalInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfessionalInfoVC"];
    
    [self.navigationController pushViewController:professionalInfoVC animated:NO];
    //[self presentViewController:professionalInfoVC  animated:false completion:nil];

    
    
    
}

- (IBAction)Portfolio:(id)sender {
 
    
    PortfolioVC *portfolioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PortfolioVC"];
    [self.navigationController pushViewController:portfolioVC animated:NO];
    
}

- (IBAction)BankDetails:(id)sender {
    
    ProfessionalBankDetailsVC *professionalBankDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfessionalBankDetailsVC"];
    
    [self.navigationController pushViewController:professionalBankDetailsVC animated:NO];
    
    
}

/*CGRect scrollFrame;
scrollFrame.origin = ScrollView.frame.origin;
scrollFrame.size = CGSizeMake(w, h);
ScrollView.frame = scrollFrame;
Edit keeping the center unchanged:

CGRect scrollFrame;
CGFloat newX = scrollView.frame.origin.x + (scrollView.frame.size.width - w) / 2;
CGFloat newY = scrollView.frame.origin.y + (scrollView.frame.size.height - y) / 2;
scrollFrame.origin = CGPointMake(newX, newY);
scrollFrame.size = CGSizeMake(w, h);
scrollView.frame = scrollFrame;*/

 
@end
