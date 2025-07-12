module fixed_point_adder #(
    parameter integer Q = 8,         // Number of fractional bits (precision)
    parameter integer N = 16         // Total bits (including sign and fractional parts)
)(
    input  wire [N-1:0] a,           // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,           // Second fixed-point operand (two's complement)
    output reg  [N-1:0] c            // Fixed-point addition result (two's complement)
);

    // Internal register to store result
    reg signed [N-1:0] res;

    always @(*) begin
        // Perform signed addition directly
        res = $signed(a) + $signed(b);
        c = res;
    end

endmodule

/*
Notes:

- 'a' and 'b' are treated as signed two's complement fixed-point numbers with Q fractional bits.
- Direct signed addition inherently handles sign, overflow (with wrap-around), and fixed-point addition semantics.
- The internal register 'res' is used as requested and updated combinationally.
- The parameter Q indicates fractional bits for interpretation but does not affect addition logic.
- This simplified design is efficient, synthesizable, and easy to integrate.
*/