module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits including sign
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for result
    reg signed [N-1:0] res;

    // Cast inputs as signed for arithmetic
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    always @* begin
        // Fixed-point addition using signed addition
        res = a_s + b_s;
        c = res;
    end

endmodule