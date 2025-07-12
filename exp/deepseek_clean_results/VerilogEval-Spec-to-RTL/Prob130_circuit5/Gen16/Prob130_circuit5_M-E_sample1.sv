module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Pattern matching for specific 'c' values
wire match_0 = ~|c;                    // c == 0
wire match_1 = (c == 4'd1);            // c == 1
wire match_2 = (c == 4'd2);            // c == 2
wire match_3 = (c == 4'd3);            // c == 3
wire out_of_range = |c[3:2];           // c >= 4

// Combine matches with corresponding inputs
wire [3:0] out_0 = {4{match_0}} & b;
wire [3:0] out_1 = {4{match_1}} & e;
wire [3:0] out_2 = {4{match_2}} & a;
wire [3:0] out_3 = {4{match_3}} & d;
wire [3:0] out_f = {4{out_of_range}} & 4'b1111;

// Combine all possible outputs
assign q = out_0 | out_1 | out_2 | out_3 | out_f;

endmodule