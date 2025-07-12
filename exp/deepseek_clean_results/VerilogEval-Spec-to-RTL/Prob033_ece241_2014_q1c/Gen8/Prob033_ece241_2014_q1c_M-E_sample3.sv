module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Precompute sum0 (c_in=0) and sum1 (c_in=1) for each bit
    wire [7:0] sum0 = a ^ b;
    wire [7:0] sum1 = ~(a ^ b);
    wire [7:0] carry_gen = a & b;
    wire [7:0] carry_prop = a ^ b;
    
    // Carry select logic
    wire [7:0] carry;
    assign carry[0] = carry_gen[0];
    
    // Conditional carry propagation
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : carry_chain
            assign carry[i] = carry_gen[i] | (carry_prop[i] & carry[i-1]);
        end
    endgenerate
    
    // Final sum selection
    assign s = sum0 ^ {carry[6:0], 1'b0};
    
    // Early overflow prediction
    wire msb_carry_in = carry[6];
    wire msb_sum = sum0[7] ^ msb_carry_in;
    assign overflow = (a[7] == b[7]) && (msb_sum != a[7]);
endmodule