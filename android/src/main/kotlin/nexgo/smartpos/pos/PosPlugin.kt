package nexgo.smartpos.pos


import android.content.Context
import androidx.annotation.NonNull
import com.nexgo.oaf.apiv3.APIProxy
import com.nexgo.oaf.apiv3.DeviceEngine
import com.nexgo.oaf.apiv3.device.led.LightModeEnum
import com.nexgo.oaf.apiv3.device.reader.CardInfoEntity
import com.nexgo.oaf.apiv3.device.reader.CardSlotTypeEnum
import com.nexgo.oaf.apiv3.device.reader.OnCardInfoListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** PosPlugin */
class PosPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  var deviceEngine: DeviceEngine? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pos")
    channel.setMethodCallHandler(this)
    // Initialize the context property
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "initDevice"){
      println("init device(get device engine)")
      deviceEngine = APIProxy.getDeviceEngine(context)
      deviceEngine?.getEmvHandler2("app2")
      result.success("Device initiated")
    } else if (call.method == "beepDevice") {
      println("Beep device called")
      val beeper = deviceEngine?.getBeeper()
      beeper?.beep(100)
      result.success(true)
    } else if (call.method == "toggleLed"){
      val hashMap = HashMap<Int, LightModeEnum>()
      hashMap[0] = LightModeEnum.BLUE
      hashMap[1] = LightModeEnum.YELLOW
      hashMap[2] = LightModeEnum.RED
      hashMap[3] = LightModeEnum.GREEN
      val state = BooleanArray(hashMap.size)
      println("Toggle Led called")
      val ledDriver = deviceEngine?.ledDriver
      state[1] = !state[1]
      ledDriver?.setLed(hashMap.get(0), true)
      result.success(true)
    } else if(call.method == "initCardReader"){
      println("Init Card reader called")
      val cardReader = deviceEngine!!.cardReader
      val slotTypes = HashSet<CardSlotTypeEnum>()
      slotTypes.add(CardSlotTypeEnum.SWIPE)
      slotTypes.add(CardSlotTypeEnum.ICC1)
      slotTypes.add(CardSlotTypeEnum.RF)
      cardReader.searchCard(slotTypes, 60, object : OnCardInfoListener {
        override  fun onCardInfo(retCode: Int, cardInfo: CardInfoEntity?) {
          if (cardInfo != null) {
            // Handle cardInfo
          }
        }

        override fun onSwipeIncorrect() {
          TODO("Not yet implemented")
        }

        override fun onMultipleCards() {
          TODO("Not yet implemented")
        }
      });
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
