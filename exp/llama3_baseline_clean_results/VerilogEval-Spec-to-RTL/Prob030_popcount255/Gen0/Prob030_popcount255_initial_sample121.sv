module TopModule(
    input  [254:0] in,  // 255-bit input
    output [7:0] out   // 8-bit output
);

// Count the number of '1's in each 16-bit group
wire [15:0] count0;
wire [15:0] count1;
wire [15:0] count2;
wire [15:0] count3;
wire [15:0] count4;
wire [15:0] count5;
wire [15:0] count6;
wire [15:0] count7;
wire [15:0] count8;
wire [15:0] count9;
wire [15:0] count10;
wire [15:0] count11;
wire [15:0] count12;
wire [15:0] count13;
wire [15:0] count14;
wire [15:0] count15;

// Count '1's in each 16-bit group
pop_count_16 pop_count_0(.in(in[15:0]),.out(count0));
pop_count_16 pop_count_1(.in(in[31:16]),.out(count1));
pop_count_16 pop_count_2(.in(in[47:32]),.out(count2));
pop_count_16 pop_count_3(.in(in[63:48]),.out(count3));
pop_count_16 pop_count_4(.in(in[79:64]),.out(count4));
pop_count_16 pop_count_5(.in(in[95:80]),.out(count5));
pop_count_16 pop_count_6(.in(in[111:96]),.out(count6));
pop_count_16 pop_count_7(.in(in[127:112]),.out(count7));
pop_count_16 pop_count_8(.in(in[143:128]),.out(count8));
pop_count_16 pop_count_9(.in(in[159:144]),.out(count9));
pop_count_16 pop_count_10(.in(in[175:160]),.out(count10));
pop_count_16 pop_count_11(.in(in[191:176]),.out(count11));
pop_count_16 pop_count_12(.in(in[207:192]),.out(count12));
pop_count_16 pop_count_13(.in(in[223:208]),.out(count13));
pop_count_16 pop_count_14(.in(in[239:224]),.out(count14));
pop_count_16 pop_count_15(.in(in[254:240]),.out(count15));

// Sum the counts of '1's in each group
wire [7:0] sum0;
wire [7:0] sum1;
wire [7:0] sum2;
wire [7:0] sum3;
wire [7:0] sum4;
wire [7:0] sum5;
wire [7:0] sum6;
wire [7:0] sum7;

// First level of addition
full_adder_8 full_add_0(.a(count0[3:0]),.b(count1[3:0]),.cin(1'b0),.s(sum0),.cout());
full_adder_8 full_add_1(.a(count2[3:0]),.b(count3[3:0]),.cin(1'b0),.s(sum1),.cout());
full_adder_8 full_add_2(.a(count4[3:0]),.b(count5[3:0]),.cin(1'b0),.s(sum2),.cout());
full_adder_8 full_add_3(.a(count6[3:0]),.b(count7[3:0]),.cin(1'b0),.s(sum3),.cout());
full_adder_8 full_add_4(.a(count8[3:0]),.b(count9[3:0]),.cin(1'b0),.s(sum4),.cout());
full_adder_8 full_add_5(.a(count10[3:0]),.b(count11[3:0]),.cin(1'b0),.s(sum5),.cout());
full_adder_8 full_add_6(.a(count12[3:0]),.b(count13[3:0]),.cin(1'b0),.s(sum6),.cout());
full_adder_8 full_add_7(.a(count14[3:0]),.b(count15[3:0]),.cin(in[254]),.s(sum7),.cout());

// Second level of addition
full_adder_8 full_add_8(.a(sum0),.b(sum1),.cin(1'b0),.s(sum0),.cout());
full_adder_8 full_add_9(.a(sum2),.b(sum3),.cin(1'b0),.s(sum1),.cout());
full_adder_8 full_add_10(.a(sum4),.b(sum5),.cin(1'b0),.s(sum2),.cout());
full_adder_8 full_add_11(.a(sum6),.b(sum7),.cin(1'b0),.s(sum3),.cout());

// Third level of addition
full_adder_8 full_add_12(.a(sum0),.b(sum1),.cin(1'b0),.s(sum0),.cout());
full_adder_8 full_add_13(.a(sum2),.b(sum3),.cin(1'b0),.s(sum1),.cout());

// Final level of addition
full_adder_8 full_add_14(.a(sum0),.b(sum1),.cin(1'b0),.s(out),.cout());

endmodule

// Module to count '1's in a 16-bit vector
module pop_count_16(
    input  [15:0] in,
    output [3:0] out
);
    assign out[0] = in[0] + in[1] + in[2] + in[3];
    assign out[1] = in[4] + in[5] + in[6] + in[7];
    assign out[2] = in[8] + in[9] + in[10] + in[11];
    assign out[3] = in[12] + in[13] + in[14] + in[15];
endmodule

// 8-bit full adder module
module full_adder_8(
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] s,
    output       cout
);
    assign s = a + b + cin;
    assign cout = (a[7] + b[7] + cin) > 8'd255;
endmodule