module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for segmented carry-lookahead
wire [3:0] seg_cout; // Segment carry-out signals
wire [3:0] seg_cin; // Segment carry-in signals

// Segment 1 (bits 0-1)
wire sum_1, cout_1;
half_adder ha1(a[0], b[0], cin, sum[0], sum_1);
full_adder fa1(a[1], b[1], sum_1, seg_cin[0], sum[1], seg_cout[0]);

// Segment 2 (bits 2-3)
wire sum_2, cout_2;
half_adder ha2(a[2], b[2], seg_cout[0], sum[2], sum_2);
full_adder fa2(a[3], b[3], sum_2, seg_cin[1], sum[3], seg_cout[1]);

// Segment 3 (bits 4-5)
wire sum_3, cout_3;
half_adder ha3(a[4], b[4], seg_cout[1], sum[4], sum_3);
full_adder fa3(a[5], b[5], sum_3, seg_cin[2], sum[5], seg_cout[2]);

// Segment 4 (bits 6-7)
wire sum_4, cout_4;
half_adder ha4(a[6], b[6], seg_cout[2], sum[6], sum_4);
full_adder fa4(a[7], b[7], sum_4, seg_cin[3], sum[7], seg_cout[3]);

// Secondary carry-lookahead circuit
assign seg_cin[0] = cin;
assign seg_cin[1] = seg_cout[0];
assign seg_cin[2] = seg_cout[1];
assign seg_cin[3] = seg_cout[2];

// Final carry-out signal
assign cout = seg_cout[3];

endmodule

module half_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule