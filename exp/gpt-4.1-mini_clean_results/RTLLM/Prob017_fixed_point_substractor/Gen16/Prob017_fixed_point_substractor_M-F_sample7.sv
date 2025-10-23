`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total number of bits including sign bit
    parameter integer Q = 8         // Number of fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point subtraction result c = a - b
);

    // Internal register to store subtraction result
    reg [N-1:0] res;

    // Combinational logic for subtraction and zero sign handling
    always @(*) begin
        res = a - b;
        // If magnitude (all bits except sign) is zero, clear the sign bit to 0
        if (res[N-2:0] == { (N-1){1'b0} }) begin
            res = {1'b0, { (N-1){1'b0} } };
        end
    end

    // Output assigned from internal result register
    always @(*) begin
        c = res;
    end

endmodule