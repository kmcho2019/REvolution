module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each 8-bit chunk
    wire [7:0] count0;
    wire [7:0] count1;
    wire [7:0] count2;
    wire [7:0] count3;
    wire [7:0] count4;
    wire [7:0] count5;
    wire [7:0] count6;
    wire [7:0] count7;
    wire [7:0] count8;
    wire [7:0] count9;
    wire [7:0] count10;
    wire [7:0] count11;
    wire [7:0] count12;
    wire [7:0] count13;
    wire [7:0] count14;
    wire [7:0] count15;
    wire [7:0] count16;
    wire [7:0] count17;
    wire [7:0] count18;
    wire [7:0] count19;
    wire [7:0] count20;
    wire [7:0] count21;
    wire [7:0] count22;
    wire [7:0] count23;
    wire [7:0] count24;
    wire [7:0] count25;
    wire [7:0] count26;
    wire [7:0] count27;
    wire [7:0] count28;
    wire [7:0] count29;
    wire [7:0] count30;
    wire [7:0] count31;

    // Count the number of '1's in the 7-bit chunk
    wire [3:0] count32;

    // Count the number of '1's in each 8-bit chunk
    PopCount8 pop_count0(.in(in[7:0]), .out(count0));
    PopCount8 pop_count1(.in(in[15:8]), .out(count1));
    PopCount8 pop_count2(.in(in[23:16]), .out(count2));
    PopCount8 pop_count3(.in(in[31:24]), .out(count3));
    PopCount8 pop_count4(.in(in[39:32]), .out(count4));
    PopCount8 pop_count5(.in(in[47:40]), .out(count5));
    PopCount8 pop_count6(.in(in[55:48]), .out(count6));
    PopCount8 pop_count7(.in(in[63:56]), .out(count7));
    PopCount8 pop_count8(.in(in[71:64]), .out(count8));
    PopCount8 pop_count9(.in(in[79:72]), .out(count9));
    PopCount8 pop_count10(.in(in[87:80]), .out(count10));
    PopCount8 pop_count11(.in(in[95:88]), .out(count11));
    PopCount8 pop_count12(.in(in[103:96]), .out(count12));
    PopCount8 pop_count13(.in(in[111:104]), .out(count13));
    PopCount8 pop_count14(.in(in[119:112]), .out(count14));
    PopCount8 pop_count15(.in(in[127:120]), .out(count15));
    PopCount8 pop_count16(.in(in[135:128]), .out(count16));
    PopCount8 pop_count17(.in(in[143:136]), .out(count17));
    PopCount8 pop_count18(.in(in[151:144]), .out(count18));
    PopCount8 pop_count19(.in(in[159:152]), .out(count19));
    PopCount8 pop_count20(.in(in[167:160]), .out(count20));
    PopCount8 pop_count21(.in(in[175:168]), .out(count21));
    PopCount8 pop_count22(.in(in[183:176]), .out(count22));
    PopCount8 pop_count23(.in(in[191:184]), .out(count23));
    PopCount8 pop_count24(.in(in[199:192]), .out(count24));
    PopCount8 pop_count25(.in(in[207:200]), .out(count25));
    PopCount8 pop_count26(.in(in[215:208]), .out(count26));
    PopCount8 pop_count27(.in(in[223:216]), .out(count27));
    PopCount8 pop_count28(.in(in[231:224]), .out(count28));
    PopCount8 pop_count29(.in(in[239:232]), .out(count29));
    PopCount8 pop_count30(.in(in[247:240]), .out(count30));
    PopCount8 pop_count31(.in(in[255:248]), .out(count31));

    PopCount7 pop_count32(.in(in[254:248]), .out(count32));

    // Add up the counts from each chunk
    wire [7:0] sum0;
    wire [7:0] sum1;
    wire [7:0] sum2;
    wire [7:0] sum3;
    wire [7:0] sum4;
    wire [7:0] sum5;
    wire [7:0] sum6;
    wire [7:0] sum7;
    wire [7:0] sum8;
    wire [7:0] sum9;
    wire [7:0] sum10;
    wire [7:0] sum11;
    wire [7:0] sum12;
    wire [7:0] sum13;
    wire [7:0] sum14;
    wire [7:0] sum15;

    FullAdder8 fa0(.a(count0), .b(count1), .cin(8'b0), .s(sum0), .cout());
    FullAdder8 fa1(.a(sum0), .b(count2), .cin(8'b0), .s(sum1), .cout());
    FullAdder8 fa2(.a(sum1), .b(count3), .cin(8'b0), .s(sum2), .cout());
    FullAdder8 fa3(.a(sum2), .b(count4), .cin(8'b0), .s(sum3), .cout());
    FullAdder8 fa4(.a(sum3), .b(count5), .cin(8'b0), .s(sum4), .cout());
    FullAdder8 fa5(.a(sum4), .b(count6), .cin(8'b0), .s(sum5), .cout());
    FullAdder8 fa6(.a(sum5), .b(count7), .cin(8'b0), .s(sum6), .cout());
    FullAdder8 fa7(.a(sum6), .b(count8), .cin(8'b0), .s(sum7), .cout());
    FullAdder8 fa8(.a(sum7), .b(count9), .cin(8'b0), .s(sum8), .cout());
    FullAdder8 fa9(.a(sum8), .b(count10), .cin(8'b0), .s(sum9), .cout());
    FullAdder8 fa10(.a(sum9), .b(count11), .cin(8'b0), .s(sum10), .cout());
    FullAdder8 fa11(.a(sum10), .b(count12), .cin(8'b0), .s(sum11), .cout());
    FullAdder8 fa12(.a(sum11), .b(count13), .cin(8'b0), .s(sum12), .cout());
    FullAdder8 fa13(.a(sum12), .b(count14), .cin(8'b0), .s(sum13), .cout());
    FullAdder8 fa14(.a(sum13), .b(count15), .cin(8'b0), .s(sum14), .cout());
    FullAdder8 fa15(.a(sum14), .b(count16), .cin(8'b0), .s(sum15), .cout());

    // Continue adding up the counts
    wire [7:0] sum16;
    wire [7:0] sum17;
    wire [7:0] sum18;
    wire [7:0] sum19;
    wire [7:0] sum20;
    wire [7:0] sum21;
    wire [7:0] sum22;
    wire [7:0] sum23;

    FullAdder8 fa16(.a(sum15), .b(count17), .cin(8'b0), .s(sum16), .cout());
    FullAdder8 fa17(.a(sum16), .b(count18), .cin(8'b0), .s(sum17), .cout());
    FullAdder8 fa18(.a(sum17), .b(count19), .cin(8'b0), .s(sum18), .cout());
    FullAdder8 fa19(.a(sum18), .b(count20), .cin(8'b0), .s(sum19), .cout());
    FullAdder8 fa20(.a(sum19), .b(count21), .cin(8'b0), .s(sum20), .cout());
    FullAdder8 fa21(.a(sum20), .b(count22), .cin(8'b0), .s(sum21), .cout());
    FullAdder8 fa22(.a(sum21), .b(count23), .cin(8'b0), .s(sum22), .cout());
    FullAdder8 fa23(.a(sum22), .b(count24), .cin(8'b0), .s(sum23), .cout());

    // Continue adding up the counts
    wire [7:0] sum24;
    wire [7:0] sum25;
    wire [7:0] sum26;
    wire [7:0] sum27;

    FullAdder8 fa24(.a(sum23), .b(count25), .cin(8'b0), .s(sum24), .cout());
    FullAdder8 fa25(.a(sum24), .b(count26), .cin(8'b0), .s(sum25), .cout());
    FullAdder8 fa26(.a(sum25), .b(count27), .cin(8'b0), .s(sum26), .cout());
    FullAdder8 fa27(.a(sum26), .b(count28), .cin(8'b0), .s(sum27), .cout());

    // Continue adding up the counts
    wire [7:0] sum28;
    wire [7:0] sum29;
    wire [7:0] sum30;

    FullAdder8 fa28(.a(sum27), .b(count29), .cin(8'b0), .s(sum28), .cout());
    FullAdder8 fa29(.a(sum28), .b(count30), .cin(8'b0), .s(sum29), .cout());
    FullAdder8 fa30(.a(sum29), .b(count31), .cin(8'b0), .s(sum30), .cout());

    // Add the count from the 7-bit chunk
    wire [7:0] sum31;

    FullAdder8 fa31(.a(sum30), .b({4'b0, count32}), .cin(8'b0), .s(sum31), .cout());

    // Output the final sum
    assign out = sum31;

endmodule

// Module to count the number of '1's in an 8-bit vector
module PopCount8(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {8{in[0]} + 8{in[1]} + 8{in[2]} + 8{in[3]} + 8{in[4]} + 8{in[5]} + 8{in[6]} + 8{in[7]}};

endmodule

// Module to count the number of '1's in a 7-bit vector
module PopCount7(
    input  [6:0] in,
    output [3:0] out
);

    assign out = {4{in[0]} + 4{in[1]} + 4{in[2]} + 4{in[3]} + 4{in[4]} + 4{in[5]} + 4{in[6]}};

endmodule

// Module for a full adder
module FullAdder8(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] cin,
    output [7:0] s,
    output [7:0] cout
);

    assign s = a + b + cin;
    assign cout = a + b + cin;

endmodule