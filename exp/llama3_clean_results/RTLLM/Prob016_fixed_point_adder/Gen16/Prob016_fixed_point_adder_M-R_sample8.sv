module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

wire [N-1:0] res;
wire [N-1:0] overflow_value;

// Determine the sign of the result
assign res = (a[N-1] == b[N-1]) ? (a + b) : ((a[N-1]) ? ((~a + 1) + b) : (a - (~b + 1)));

// Saturate the result to handle overflows
assign overflow_value = (res[N-1] && ~a[N-1] && ~b[N-1]) ? {1'b0, {N-1{1'b1}}} : 
                       (~res[N-1] && a[N-1] && b[N-1]) ? {1'b1, {N-1{1'b0}}} : {N{1'b0}};

// Assign the result or the saturated value to the output
assign c = (overflow_value != {N{1'b0}}) ? overflow_value : res;

endmodule