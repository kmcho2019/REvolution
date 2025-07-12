module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Registered inputs to reduce switching power
    reg signed [63:0] A_reg, B_reg;
    always @(*) begin
        A_reg = A;
        B_reg = B;
    end

    // Carry-lookahead implementation of subtraction (A - B = A + ~B + 1)
    wire [63:0] B_comp = ~B_reg;
    wire [64:0] carry_chain;
    assign carry_chain[0] = 1'b1; // +1 for two's complement
    
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : sub_adder
            // Propagate and generate signals
            wire p = A_reg[i] ^ B_comp[i];
            wire g = A_reg[i] & B_comp[i];
            
            // Carry lookahead
            assign carry_chain[i+1] = g | (p & carry_chain[i]);
            
            // Sum calculation
            assign result[i] = p ^ carry_chain[i];
        end
    endgenerate

    // Overflow detection (shared XOR with subtraction)
    assign overflow = (A_reg[63] ^ B_reg[63]) && (A_reg[63] ^ result[63]);

endmodule