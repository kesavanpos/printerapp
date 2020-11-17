import { Component, OnInit } from "@angular/core";

import { Item } from "./item";
import { ItemService } from "./item.service";

import * as dialogs from "tns-core-modules/ui/dialogs";
import { Bluetooth } from '@nativescript-community/ble';

declare var LabelPrinterSDK:any;

declare var printerwrapper:any;

@Component({
    selector: "ns-items",
    templateUrl: "./items.component.html"
})
export class ItemsComponent implements OnInit {
    items: Array<Item>;

    public input: any;
    constructor(private itemService: ItemService) {
        this.input = {
            "xPos":"",
            "yPos":"",
            "startPage":"",
            "endPage":"",
            "width":""
        };

     }

    ngOnInit(): void {        

    }
     printer:any
    CheckPrinterConnected(e){
        if(this.printer == null || this.printer == undefined)
        {
            this.printer = new printerwrapper();
        }
       var isconnected = this.printer.isPrinterConnected();

       dialogs.alert(isconnected).then(function() {
        console.log("Dialog closed!");
        });
    }

    

    print(e)
    {
        if(this.printer == null || this.printer == undefined)
        {
            this.printer = new printerwrapper();
        }

        console.log(this.input);

        var finalvalue = this.input.xPos.toString() + "," + this.input.yPos.toString() + "," + this.input.startPage.toString() + "," + this.input.endPage.toString() + "," + this.input.width.toString()

        var result = this.printer.print(finalvalue);
        
        dialogs.alert(result).then(function() {
            console.log("Dialog closed!");
        });
    }

    GetPairedDevices(e){
        
        if(this.printer == null || this.printer == undefined)
        {
            this.printer = new printerwrapper();
        }
       var bluetoothname = this.printer.getPairedDevices();

       dialogs.alert(bluetoothname).then(function() {
        console.log("Dialog closed!");
      });
    }

    doEnableBluetooth() {

        let test = new Bluetooth();
        test.isBluetoothEnabled().then(function(enabled){
            if(!enabled)
            {
                setTimeout(function() {
                    dialogs.alert({
                      title: "Enable Bluetooth",
                      message: enabled ? "Yes" : "No",
                      okButtonText: "OK"
                    });
                  }, 500);
            }
        });
      }
}
