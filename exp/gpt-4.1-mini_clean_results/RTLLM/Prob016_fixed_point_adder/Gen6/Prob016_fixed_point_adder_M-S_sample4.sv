module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits
    parameter integer N = 16           // Total bits including sign bit
)(
    input  wire [N-1:0] a,             // Fixed-point input operand a
    input  wire [N-1:0] b,             // Fixed-point input operand b
    output reg  [N-1:0] c              // Fixed-point output result
);

    reg [N:0] res_ext;                 // Extended result with extra bit for carry

    always @* begin
        res_ext = {1'b0, a} + {1'b0, b};  // Add with zero-extended to N+1 bits
        res = res_ext[N-1:0];              // Truncate to N bits (two's complement)
        c = res;
    end

    reg [N-1:0] res;

endmodule