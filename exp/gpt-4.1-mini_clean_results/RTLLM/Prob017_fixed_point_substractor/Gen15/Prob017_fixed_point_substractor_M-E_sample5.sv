`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total bits including sign bit
    parameter integer Q = 8         // Fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point subtraction result c = a - b
);

    // Internal register for subtraction result
    reg [N-1:0] res;

    // Wire for checking if result magnitude is zero
    wire is_zero;

    // Perform subtraction in two's complement (fixed-point)
    always @(*) begin
        res = a - b;
        // If result magnitude is zero (ignoring sign), force sign bit to zero
        if ((res[N-2:0] == 0)) 
            res = {1'b0, { (N-1) {1'b0} } };
    end

    // Assign result to output
    always @(*) begin
        c = res;
    end

endmodule