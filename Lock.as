package {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class Lock extends MovieClip{

    private var eventTimer:Timer;
    private var lockPosition:int;
    private var key1:int;
    private var key2:int;
    private var key3:int;
    private var key1open:Boolean;
    private var key2open:Boolean;
	private var lockSound:LockMoveSound;
	
    public function Lock(){

        this.eventTimer = new Timer(100);
        this.lockPosition = 0;
        this.key1 = 21;
        this.key2 = 3;
        this.key3 = 16;
        this.eventTimer.addEventListener(TimerEvent.TIMER, clickHandler);
        addEventListener(MouseEvent.MOUSE_DOWN, onPress);
        addEventListener(MouseEvent.MOUSE_UP, onRelease);
        addEventListener(MouseEvent.MOUSE_OUT, onRelease);
        addEventListener(MouseEvent.CLICK, clickHandler);
		this.lockSound = new LockMoveSound();
    }

    private function onRelease(event:MouseEvent):void {
        this.eventTimer.stop();
    }

    private function onPress(event:MouseEvent):void{
        this.eventTimer.start();
    }

    // Function to check the lock combination and reset in case that its wrong.
    private function checkLock():void {

        if (!key1open) {
            if (this.lockPosition == this.key1) this.key1open = true;
        }
        else if (key1open && !key2open) {
            if (this.lockPosition > this.key1) this.key1open = false;
            if (this.lockPosition == this.key2) this.key2open = true;
        }
        else {

            if (this.lockPosition < this.key2) {
                this.key2open = false;
                this.key1open = false;
            }
            if (this.lockPosition == this.key3) {
                MovieClip(this.parent).gotoAndStop(2);
            }

        }
    }

    private function clickHandler(event:Event):void {

        //If Mouse is clicking the Lock
        if(this.hitTestPoint(stage.mouseX ,stage.mouseY, true)){

            //If the click is inside the circle
            if (Math.sqrt((stage.mouseX - this.x)*(stage.mouseX - this.x) +
                            (stage.mouseY - this.y)*(stage.mouseY - this.y)) < (this.width/2)){

				this.lockSound.play();
                //If the click is on left side of the circle else is on right
                if(stage.mouseX < this.x){
                    this.rotation += 3.6;
                    this.lockPosition--;
                }else{
                    this.rotation -= 3.6;
                    this.lockPosition++;
                }

            }
        }

        if(Math.round(this.rotation) == 0) this.lockPosition = 0;
        checkLock();
    }
}
}
