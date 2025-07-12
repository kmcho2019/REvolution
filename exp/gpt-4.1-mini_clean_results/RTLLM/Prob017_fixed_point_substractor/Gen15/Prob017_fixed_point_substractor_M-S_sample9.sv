`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,    // Total bits including sign
    parameter integer Q = 8      // Fractional bits
)(
    input  wire [N-1:0] a,       // Input operand a (two's complement fixed-point)
    input  wire [N-1:0] b,       // Input operand b (two's complement fixed-point)
    output wire [N-1:0] c        // Result c = a - b (two's complement fixed-point)
);

    reg signed [N-1:0] res;

    // Perform signed subtraction
    always @(*) begin
        res = $signed(a) - $signed(b);
        // If result is zero, clear sign bit explicitly
        if (res == 0)
            res = {1'b0, {(N-1){1'b0}}};
    end

    assign c = res;

endmodule