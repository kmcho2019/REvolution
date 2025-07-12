module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits (precision)
    parameter integer N = 16       // Total number of bits including sign and fractional bits
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point input operand A
    input  wire signed [N-1:0] b,  // Signed fixed-point input operand B
    output reg  signed [N-1:0] c   // Signed fixed-point addition result
);

    // Internal register to hold result
    reg signed [N-1:0] res;

    always @(*) begin
        res = a + b;   // Signed addition of fixed-point numbers
        c   = res;     // Output assigned to the register value
    end

endmodule