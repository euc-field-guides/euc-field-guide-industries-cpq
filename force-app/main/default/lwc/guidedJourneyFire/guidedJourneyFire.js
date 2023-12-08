// pubsub.fire(`${this.channelName}_${this.recordId}`, "cpq_reload_catalog");

// pubsub.fire(`${this.channelName}_${this.recordId}`, "cpq_cart_updated", {
//           response: response.IPResult,
//           isMultisiteFlow: this.isMultisiteFlow
//         });


import { LightningElement, api} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import pubsub from 'vlocity_cmt/pubsub';
import * as cpqDataLayer from 'vlocity_cmt/cpqDataLayerUtil';
import { getDataHandler, namespace } from "vlocity_cmt/utility";
export default class guidedJourneyFire extends OmniscriptBaseMixin(LightningElement) {
      
    _cartId;
    _currentTab;
        @api set cartId(val) {
            if (val) {
                this._cartId = val;
            }
        }

        @api set currentTab(val) {
            if (val) {
              this._currentTab = val;
              cpqDataLayer.updateCurrentTab(val);
            }
        }
  get currentTab() {
    return this._currentTab;
  }
        get cartId() {
            return this._cartId;
        }


        /*connectedCallback() {
          pubsub.fire(`cpq_${this.recordId}`, "cpq_reload_catalog");
          //super.connectedCallback();
          this.handleOmniActionEvent = {
              data: this.handleOmniAction.bind(this)
          }
          
      }*/

      

      disconnectedCallback() {
          pubsub.unregister(`cpq_${this.cartId}`, this.handleGroupSelectEvent);
      }


  
        connectedCallback() {
            console.log('cart id guidedJourneyFire===', this.cartId);
            console.log('current tab guidedJourneyFire===', this.currentTab);
            new Promise((resolve, reject) => {
                if (this.cartId) {
                  console.log('==inside if guidedJourneyFire===');
                  console.log('==before fired guidedJourneyFire===');
                  pubsub.fire(`cpq_${this.cartId}`, "cpq_reload_catalog");
                  pubsub.fire(`cpq_${this.cartId}`, "cpq_catalog_item_select_browse")
                  console.log('==reload fired guidedJourneyFire===');
                  console.log('channel: ' + `cpq_${this.cartId}` + ' - message: cpq_reload_catalog');
                  /*this.handleOmniActionEvent = {
                    data: this.handleOmniAction.bind(this)
                  };*/
                  resolve();
                } else {
                  console.log('==Missing recordId===');
                  reject(new Error('Missing recordId'));
                }
              }).catch(error => console.error(error));
          }


          /*handleOmniAction(data) {
            // perform logic to handle the Action's response data
            console.log('==data==',data);
          }*/

        

        /*disconnectedCallback() {
            console.log('==disconnectedCallback===');
            pubsub.unregister(`cpq_${this.cartId}`, this.handleGroupSelectEvent);
        }*/
    
    }