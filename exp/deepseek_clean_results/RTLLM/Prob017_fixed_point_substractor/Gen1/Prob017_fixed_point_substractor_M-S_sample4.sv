module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire [N-1:0] b_neg = ~b + 1;  // Two's complement of b

always @(*) begin
    // Perform subtraction using two's complement addition
    c = a + b_neg;
    
    // Handle zero case explicitly
    if (c[N-2:0] == 0)
        c[N-1] = 0;
end

endmodule