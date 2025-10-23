module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Create condition masks for each valid c value
wire cond0 = ~|c;                      // c == 0
wire cond1 = (c == 4'd1);              // c == 1
wire cond2 = (c == 4'd2);              // c == 2
wire cond3 = (c == 4'd3);              // c == 3
wire default_case = |c[3:2] || (c > 4'd3); // c > 3

// Generate masked versions of each possible output
wire [3:0] out0 = b & {4{cond0}};
wire [3:0] out1 = e & {4{cond1}};
wire [3:0] out2 = a & {4{cond2}};
wire [3:0] out3 = d & {4{cond3}};
wire [3:0] out_default = {4{default_case}}; // All 1s when default

// Combine all possible outputs (priority encoded)
assign q = out0 | out1 | out2 | out3 | out_default;

endmodule