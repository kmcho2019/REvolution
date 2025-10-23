module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total number of bits (including sign)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    reg signed [N:0] res; // One extra bit to detect overflow if needed

    always @(*) begin
        res = a + b;       // Signed addition including fractional bits
    end

    // Output: lower N bits of result (overflow wraps around)
    assign c = res[N-1:0];

endmodule