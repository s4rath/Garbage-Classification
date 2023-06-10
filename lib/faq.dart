import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQs extends StatefulWidget {
  @override
  _FAQsState createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  List<Info> infos =[
  Info(title: 'What is waste management?',subtitle: 'Waste management is the collection, transportation and disposal of waste materials.'),
  Info(title: 'What are the common methods of waste disposal?',subtitle: 'The commonly practiced technologies for SWM can be grouped under three major categories, i.e., bio-processing, thermal processing and sanitary landfill. The bio-processing method includes aerobic and anaerobic composting. Thermal methods are incineration and pyrolysis. Sanitary landfill is generally used to dispose off the final rejects coming out of the biological and thermal waste processing units.'),
  Info(title: 'What is incineration?',subtitle: 'Incineration is a waste treatment process that involves the combustion of organic substances contained in waste materials. Incineration of waste materials converts the waste into ash, flue gas, and heat. In some cases, the heat generated by incineration can be used to generate electric power.'),
  Info(title: 'How do I manage my garden waste?',subtitle: 'You can compost your garden waste. There are several decentralized, easy to use methods available for composting garden waste. '),
  Info(title: 'How do I practice waste management at home?',subtitle: '''
  - Keep separate containers for dry and wet waste in the kitchen.
  - Keep two bags for dry waste collection
  - paper and plastic, for the rest of the household waste.
  - Keep plastic from the kitchen clean and dry and drop into the dry waste bin. Keep glass plastic containers rinsed of food matter.
  - Keep a paper bag for throwing sanitary waste.''' ),
  Info(title: 'What are the first few steps to initiate a waste management programme?',subtitle: '''
  - Form a group with like-minded people.
  - Explain waste segregation to your family / neighbours in your apartment building.
  - Get the staff in the apartment building to also understand its importance.
  - Get separate storage drums for storing dry and wet waste.
  - Have the dry waste picked up by the dry waste collection centre or your local scrap dealer.'''),
  ];
  Widget infoTemplate(info){
    return  
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFF7CC00),
        ) ,
        child: ExpansionTile(
          title: Text(
            info.title,
            style:GoogleFonts.poppins(fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          children: <Widget>[
            ListTile(
              title: Text(
                info.subtitle,
                style: GoogleFonts.poppins(color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return  
    Align(
      alignment:Alignment.topCenter,
      child: Container(
        height: MediaQuery.of(context).size.height-80,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFFFFDD0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('FAQs',style: GoogleFonts.poppins(fontSize: 36,color: Colors.black,fontWeight: FontWeight.w500),),
              ),
              Column(
                children: infos.map((info) => infoTemplate(info)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Info {
  String title;
  String subtitle;

  Info({required this.title,required this.subtitle});
}
