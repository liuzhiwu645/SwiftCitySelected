//
//  ViewController.swift
//  CitySelectDemo
//
//  Created by cheng on 2020/11/3.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableViewCity : UITableView!
    
    let citys = ["长沙", "北京市", "上海市", "天津市", "重庆市", "合肥市", "毫州市", "芜湖市", "马鞍山市", "池州市", "黄山市", "滁州市", "安庆市", "淮南市", "淮北市", "蚌埠市", "巢湖市", "宿州市", "六安市", "阜阳市", "铜陵市", "明光市", "天长市", "宁国市", "界首市", "桐城市", "广州市", "韶关市", "深圳市", "珠海市", "汕头市", "佛山市", "江门市", "湛江市", "茂名市", "肇庆市", "惠州市", "梅州市", "汕尾市", "河源市", "阳江市", "清远市", "东莞市", "中山市", "潮州市", "揭阳市", "云浮市", "昆明市", "曲靖市", "玉溪市", "保山市", "昭通市", "丽江市", "思茅市", "临沧市", "楚雄彝族自治州", "红河哈尼族彝族自治州", "文山壮族苗族自治州", "西双版纳傣族自治州", "大理白族自治州", "德宏傣族景颇族自治州", "怒江傈僳族自治州", "迪庆藏族自治州"]

    //存放相同首字母的城市数组
    var cityGroups = [String:[String]]()
    //存放所有地址首字母
    var groupTitles = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationItem.title = "城市选择"
        
        creat_cityTableView()
        
        addCityData()
    }
    
    func addCityData() {
        
        //遍历城市数组
        for city in citys {
           //将城市名字转化成拼音
            var cityMutableString = NSMutableString(string: city);
                        
            cityMutableString = self.transformMandarinToLatin(cityMutableString: cityMutableString)
            
            //拿到拼音首字母作为key,并转化成大写
            let firstLetter = cityMutableString.substring(to: 1).uppercased()
            //NSLog("firstLetter = %@", firstLetter);
            //判断:检查是否存在以firstLetter为数组对应的分组存在,如果有就添加到对应的分组中,否则就新建一个以firstLetter为可以的数组
            if var value = cityGroups[firstLetter] {
                //存在,就添加
                value.append(city)
                cityGroups[firstLetter] = value
            }
            else
            {
                cityGroups[firstLetter] = [city]
            }

        }
        //拿到所有的key将他排序,作为每组的标题
        groupTitles = cityGroups.keys.sorted()
        
        //自定义表格索引
        let items = self.items()
        let configuration = SectionIndexViewConfiguration.init()
        configuration.adjustedContentInset = UIApplication.shared.statusBarFrame.size.height + 44
        self.tableViewCity.sectionIndexView(items: items, configuration: configuration)
       
    }
    
    private func items() -> [SectionIndexViewItemView] {
        var items = [SectionIndexViewItemView]()
        for title in self.groupTitles {
            let item = SectionIndexViewItemView.init()
            item.title = title
            item.indicator = SectionIndexViewItemIndicator.init(title: title)
            items.append(item)
        }
        return items
    }
    /// 创建城市表格
    func creat_cityTableView() {
        
        self.tableViewCity = ({
            let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellCity")
            self.view.addSubview(tableView)
            return tableView
        })()
    }
    
    //设置索引
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return groupTitles
//    }
//
    //索引点击事件(如果实现这个方法需要我们自己实现滚到到当前section)
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        NSLog("title = %@ index = %d", title, index)
//        return groupTitles.count
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let firstLetter = groupTitles[section]
        return cityGroups[firstLetter]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCity : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellCity")!
        let firstLetter = groupTitles[indexPath.section]
        let citysInAGroup = cityGroups[firstLetter]!
        cellCity.textLabel?.text = citysInAGroup[indexPath.row]
        return cellCity
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        NSLog("title = %@", groupTitles[section])
        return groupTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    /// 多音字处理
    /// - Parameter string: 出入的字符串
    /// - Returns: 返回去的字符串
    func transformMandarinToLatin(cityMutableString : NSMutableString) -> NSMutableString {
        
        /*复制出一个可变的对象*/
        let preString :NSMutableString = NSMutableString(string: cityMutableString)
        
        //转换成成带音 调的拼音
        CFStringTransform(preString, nil, kCFStringTransformToLatin, false)
        //去掉音调
        CFStringTransform(preString, nil, kCFStringTransformStripDiacritics, false)
        
        NSLog("cityMutableString = %@", cityMutableString);
        
        if cityMutableString.substring(to: 1).compare("长") == ComparisonResult.orderedSame{
            preString.replaceCharacters(in: NSRange(location: 0,length: 5), with: "chang")
        }
        if cityMutableString.substring(to: 1).compare("沈") == ComparisonResult.orderedSame
        {
            preString.replaceCharacters(in: NSRange(location: 0,length: 4), with: "shen")
        }
        if cityMutableString.substring(to: 1).compare("厦") == ComparisonResult.orderedSame
        {
            preString.replaceCharacters(in: NSRange(location: 0,length: 4), with: "xia")
        }
        if cityMutableString.substring(to: 1).compare("地") == ComparisonResult.orderedSame
        {
            preString.replaceCharacters(in: NSRange(location: 0,length: 3), with: "di")
        }
        if cityMutableString.substring(to: 1).compare("重") == ComparisonResult.orderedSame
        {
            preString.replaceCharacters(in: NSRange(location: 0,length: 5), with: "chong")
        }
        
        return preString
    }
    
}

