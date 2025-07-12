module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Internal register with one extra bit for carry/overflow detection
    reg [N:0] sum_ext;

    always @(*) begin
        // Extend inputs to signed integers for addition
        sum_ext = {a[N-1], a} + {b[N-1], b};
        // Assign truncated result to output
        c = sum_ext[N-1:0];
    end

endmodule