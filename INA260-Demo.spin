{
    --------------------------------------------
    Filename: INA260-Demo.spin
    Author: Jesse Burt
    Description: Simple demo of the INA260 driver
    Copyright (c) 2020
    Started Jan 18, 2020
    Updated May 30, 2021
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' -- User-modifiable constants
    LED         = cfg#LED1
    SER_BAUD    = 115_200

    I2C_SCL     = 28
    I2C_SDA     = 29
    I2C_HZ      = 400_000                       ' max is 400_000
    ADDR_BITS   = %0000                         ' %0000..%1111 (see driver)
' --

    VBUS_COL    = 0
    I_COL       = VBUS_COL+15
    P_COL       = I_COL+15

OBJ

    ser         : "com.serial.terminal.ansi"
    cfg         : "core.con.boardcfg.flip"
    time        : "time"
    ina260      : "sensor.power.ina260.i2c"
    int         : "string.integer"

PUB Main{} | vbus, i, p

    setup{}

    ser.position(VBUS_COL, 3)
    ser.str(string("Bus voltage"))
    ser.position(I_COL, 3)
    ser.str(string("Current"))
    ser.position(P_COL, 3)
    ser.str(string("Power"))

    repeat
        repeat until ina260.conversionready{}
        vbus := ina260.busvoltage{}
        i := ina260.current{}
        p := ina260.power{}

        ser.position(VBUS_COL, 5)
        decimal(vbus, 1_000_000)
        ser.char("V")

        ser.position(I_COL, 5)
        decimal(i, 1_000_000)
        ser.char("A")

        ser.position(P_COL, 5)
        decimal(p, 1_000_000)
        ser.char("W")
        ser.clearline{}

PRI Decimal(scaled, divisor) | whole[4], part[4], places, tmp, sign
' Display a scaled up number as a decimal
'   Scale it back down by divisor (e.g., 10, 100, 1000, etc)
    whole := scaled / divisor
    tmp := divisor
    places := 0
    part := 0
    sign := 0
    if scaled < 0
        sign := "-"
    else
        sign := " "

    repeat
        tmp /= 10
        places++
    until tmp == 1
    scaled //= divisor
    part := int.deczeroed(||(scaled), places)

    ser.char(sign)
    ser.dec(||(whole))
    ser.char(".")
    ser.str(part)

PUB Setup{}

    ser.start(SER_BAUD)
    time.msleep(30)
    ser.clear{}
    ser.strln(string("Serial terminal started"))
    if ina260.startx(I2C_SCL, I2C_SDA, I2C_HZ, ADDR_BITS)
        ser.strln(string("INA260 driver started"))
    else
        ser.strln(string("INA260 driver failed to start - halting"))
        repeat

DAT
{
    --------------------------------------------------------------------------------------------------------
    TERMS OF USE: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    --------------------------------------------------------------------------------------------------------
}                                                                                                                
