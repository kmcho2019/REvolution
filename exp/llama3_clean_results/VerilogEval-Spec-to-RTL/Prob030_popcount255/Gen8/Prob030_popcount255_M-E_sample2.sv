module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input vector into 16-bit segments
    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15;

    // Count '1's in each 16-bit segment using a simple combinatorial circuit
    count_16bits count0_inst (.in(in[ 15:  0]), .out(count0));
    count_16bits count1_inst (.in(in[ 31: 16]), .out(count1));
    count_16bits count2_inst (.in(in[ 47: 32]), .out(count2));
    count_16bits count3_inst (.in(in[ 63: 48]), .out(count3));
    count_16bits count4_inst (.in(in[ 79: 64]), .out(count4));
    count_16bits count5_inst (.in(in[ 95: 80]), .out(count5));
    count_16bits count6_inst (.in(in[111: 96]), .out(count6));
    count_16bits count7_inst (.in(in[127:112]), .out(count7));
    count_16bits count8_inst (.in(in[143:128]), .out(count8));
    count_16bits count9_inst (.in(in[159:144]), .out(count9));
    count_16bits count10_inst (.in(in[175:160]), .out(count10));
    count_16bits count11_inst (.in(in[191:176]), .out(count11));
    count_16bits count12_inst (.in(in[207:192]), .out(count12));
    count_16bits count13_inst (.in(in[223:208]), .out(count13));
    count_16bits count14_inst (.in(in[239:224]), .out(count14));
    count_16bits count15_inst (.in(in[254:240]), .out(count15));

    // Sum the counts from each segment in a hierarchical manner
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
    assign sum0 = count0 + count1;
    assign sum1 = count2 + count3;
    assign sum2 = count4 + count5;
    assign sum3 = count6 + count7;
    assign sum4 = count8 + count9;
    assign sum5 = count10 + count11;
    assign sum6 = count12 + count13;
    assign sum7 = count14 + count15;

    wire [7:0] sum8, sum9, sum10, sum11;
    assign sum8 = sum0 + sum1;
    assign sum9 = sum2 + sum3;
    assign sum10 = sum4 + sum5;
    assign sum11 = sum6 + sum7;

    wire [7:0] sum12, sum13;
    assign sum12 = sum8 + sum9;
    assign sum13 = sum10 + sum11;

    assign out = sum12 + sum13;

endmodule

module count_16bits(
    input [15:0] in,
    output [7:0] out
);

    // Count '1's in the 16-bit input vector using a simple combinatorial circuit
    reg [3:0] count;
    always @(*) begin
        count = 0;
        for (int i = 0; i < 16; i++) begin
            if (in[i]) begin
                count = count + 1;
            end
        end
    end
    assign out = count;

endmodule