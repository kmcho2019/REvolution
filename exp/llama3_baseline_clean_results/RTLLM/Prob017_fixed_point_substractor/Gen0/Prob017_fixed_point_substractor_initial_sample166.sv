module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

    // Internal wire to hold the result of the subtraction or addition
    wire [N:0] res_wire;

    // Perform subtraction or addition based on the signs of a and b
    assign res_wire = (a[N-1] == b[N-1]) ? (a - b) : (a[N-1] == 1'b0) ? (a + (~b + 1'b1)) : ((~a + 1'b1) + b);

    // Handle the case where the result is zero to ensure sign bit is 0
    // Since the result is N+1 bits after the operation, we need to adjust it back to N bits
    // while handling the sign bit correctly
    assign c = (res_wire[N] == 1'b0 && res_wire[N-1:0] == {N{1'b0}}) ? {N{1'b0}} :
               (res_wire[N] == 1'b1) ? {~res_wire[N-1:0] + 1'b1, 1'b1} :
               res_wire[N-1:0];

endmodule