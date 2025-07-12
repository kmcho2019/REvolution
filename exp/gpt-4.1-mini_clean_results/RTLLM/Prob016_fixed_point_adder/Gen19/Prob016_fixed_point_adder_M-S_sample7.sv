module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total bits including sign and fractional bits
)(
    input  wire [N-1:0] a,            // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,            // Second fixed-point operand (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Perform two's complement addition directly
    wire [N:0] sum = {a[N-1], a} + {b[N-1], b}; // Extend sign bit for correct addition

    // Assign lower N bits as output (wrap-around on overflow)
    assign c = sum[N-1:0];

endmodule