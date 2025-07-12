module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Operand conditioning with isolation
    wire [7:0] b_operand = do_sub ? ~b : b;
    
    // 4-bit carry lookahead units
    wire [3:0] p0 = a[3:0] ^ b_operand[3:0];
    wire [3:0] g0 = a[3:0] & b_operand[3:0];
    wire [3:0] p1 = a[7:4] ^ b_operand[7:4];
    wire [3:0] g1 = a[7:4] & b_operand[7:4];
    
    // Carry generation
    wire c4 = g0[3] | (p0[3] & (g0[2] | (p0[2] & (g0[1] | (p0[1] & g0[0])))));
    
    // Sum generation
    wire [7:0] sum = {p1 ^ {g1[2:0], c4}, p0} + {8{do_sub}};
    
    // Optimized zero detection
    wire zero_lower = ~|sum[3:0];
    wire zero_upper = ~|sum[7:4];
    
    assign out = sum;
    assign result_is_zero = zero_lower & zero_upper;

endmodule