module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    // Declare wires to hold the counts from each byte
    wire [7:0] count_byte0;
    wire [7:0] count_byte1;
    wire [7:0] count_byte2;
    wire [7:0] count_byte3;
    wire [7:0] count_byte4;
    wire [7:0] count_byte5;
    wire [7:0] count_byte6;
    wire [7:0] count_byte7;
    wire [7:0] count_byte8;
    wire [7:0] count_byte9;
    wire [7:0] count_byte10;
    wire [7:0] count_byte11;
    wire [7:0] count_byte12;
    wire [7:0] count_byte13;
    wire [7:0] count_byte14;
    wire [7:0] count_byte15;
    wire [7:0] count_byte16;
    wire [7:0] count_byte17;
    wire [7:0] count_byte18;
    wire [7:0] count_byte19;
    wire [7:0] count_byte20;
    wire [7:0] count_byte21;
    wire [7:0] count_byte22;
    wire [7:0] count_byte23;
    wire [7:0] count_byte24;
    wire [7:0] count_byte25;
    wire [7:0] count_byte26;
    wire [7:0] count_byte27;
    wire [7:0] count_byte28;
    wire [7:0] count_byte29;
    wire [7:0] count_byte30;
    wire [7:0] count_byte31;

    // Instantiate a counter for each byte
    ByteCounter byte_counter0(in[7:0], count_byte0);
    ByteCounter byte_counter1(in[15:8], count_byte1);
    ByteCounter byte_counter2(in[23:16], count_byte2);
    ByteCounter byte_counter3(in[31:24], count_byte3);
    ByteCounter byte_counter4(in[39:32], count_byte4);
    ByteCounter byte_counter5(in[47:40], count_byte5);
    ByteCounter byte_counter6(in[55:48], count_byte6);
    ByteCounter byte_counter7(in[63:56], count_byte7);
    ByteCounter byte_counter8(in[71:64], count_byte8);
    ByteCounter byte_counter9(in[79:72], count_byte9);
    ByteCounter byte_counter10(in[87:80], count_byte10);
    ByteCounter byte_counter11(in[95:88], count_byte11);
    ByteCounter byte_counter12(in[103:96], count_byte12);
    ByteCounter byte_counter13(in[111:104], count_byte13);
    ByteCounter byte_counter14(in[119:112], count_byte14);
    ByteCounter byte_counter15(in[127:120], count_byte15);
    ByteCounter byte_counter16(in[135:128], count_byte16);
    ByteCounter byte_counter17(in[143:136], count_byte17);
    ByteCounter byte_counter18(in[151:144], count_byte18);
    ByteCounter byte_counter19(in[159:152], count_byte19);
    ByteCounter byte_counter20(in[167:160], count_byte20);
    ByteCounter byte_counter21(in[175:168], count_byte21);
    ByteCounter byte_counter22(in[183:176], count_byte22);
    ByteCounter byte_counter23(in[191:184], count_byte23);
    ByteCounter byte_counter24(in[199:192], count_byte24);
    ByteCounter byte_counter25(in[207:200], count_byte25);
    ByteCounter byte_counter26(in[215:208], count_byte26);
    ByteCounter byte_counter27(in[223:216], count_byte27);
    ByteCounter byte_counter28(in[231:224], count_byte28);
    ByteCounter byte_counter29(in[239:232], count_byte29);
    ByteCounter byte_counter30(in[247:240], count_byte30);
    ByteCounter byte_counter31(in[255:248], count_byte31);

    // Sum up the counts from each byte
    assign out = count_byte0 + count_byte1 + count_byte2 + count_byte3 + count_byte4 + count_byte5 + count_byte6 + count_byte7 +
                  count_byte8 + count_byte9 + count_byte10 + count_byte11 + count_byte12 + count_byte13 + count_byte14 + count_byte15 +
                  count_byte16 + count_byte17 + count_byte18 + count_byte19 + count_byte20 + count_byte21 + count_byte22 + count_byte23 +
                  count_byte24 + count_byte25 + count_byte26 + count_byte27 + count_byte28 + count_byte29 + count_byte30 + count_byte31;

endmodule

// Define a module to count the number of '1's in a byte
module ByteCounter(
    input  [7:0] in,
    output [7:0] out
);

    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];

endmodule