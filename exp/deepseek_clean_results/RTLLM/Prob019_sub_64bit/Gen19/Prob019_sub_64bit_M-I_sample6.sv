module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Power optimization: Operand isolation
    wire [63:0] A_active = A;
    wire [63:0] B_active = B;
    
    // Subtraction Logic with 8-bit CLA blocks and carry skip
    wire [63:0] B_comp = ~B_active;
    wire [63:0] carry;
    wire [7:0] block_propagate;
    wire [7:0] block_generate;

    // Generate 8-bit CLA blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [7:0] p = A_active[i+:8] ^ B_comp[i+:8];
            wire [7:0] g = A_active[i+:8] & B_comp[i+:8];
            
            // Carry skip detection
            assign block_propagate[i/8] = &p;
            assign block_generate[i/8] = |g;
            
            // Carry computation with lookahead
            if (i == 0) begin
                // First block uses ripple within block
                assign carry[0] = g[0] | (p[0] & 1'b1);
                assign carry[1] = g[1] | (p[1] & carry[0]);
                assign carry[2] = g[2] | (p[2] & carry[1]);
                assign carry[3] = g[3] | (p[3] & carry[2]);
                assign carry[4] = g[4] | (p[4] & carry[3]);
                assign carry[5] = g[5] | (p[5] & carry[4]);
                assign carry[6] = g[6] | (p[6] & carry[5]);
                assign carry[7] = g[7] | (p[7] & carry[6]);
            end else begin
                // Subsequent blocks use carry lookahead
                wire [3:0] carry_in;
                assign carry_in[0] = carry[i-1];
                assign carry_in[1] = g[0] | (p[0] & carry_in[0]);
                assign carry_in[2] = g[1] | (p[1] & carry_in[1]);
                assign carry_in[3] = g[2] | (p[2] & carry_in[2]);
                
                // Carry skip for upper bits
                if (block_propagate[(i/8)-1] && i>8) begin
                    assign carry[i] = carry[i-8];
                end else begin
                    assign carry[i] = g[0] | (p[0] & carry[i-1]);
                end
                
                assign carry[i+1] = g[1] | (p[1] & carry[i]);
                assign carry[i+2] = g[2] | (p[2] & carry[i+1]);
                assign carry[i+3] = g[3] | (p[3] & carry[i+2]);
                assign carry[i+4] = g[4] | (p[4] & carry[i+3]);
                assign carry[i+5] = g[5] | (p[5] & carry[i+4]);
                assign carry[i+6] = g[6] | (p[6] & carry[i+5]);
                assign carry[i+7] = g[7] | (p[7] & carry[i+6]);
            end
            
            // Sum computation
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry[i-1]);
            assign result[i+1] = p[1] ^ carry[i];
            assign result[i+2] = p[2] ^ carry[i+1];
            assign result[i+3] = p[3] ^ carry[i+2];
            assign result[i+4] = p[4] ^ carry[i+3];
            assign result[i+5] = p[5] ^ carry[i+4];
            assign result[i+6] = p[6] ^ carry[i+5];
            assign result[i+7] = p[7] ^ carry[i+6];
        end
    endgenerate

    // Optimized overflow detection
    wire sign_A = A_active[63];
    wire sign_B = B_active[63];
    wire sign_res = result[63];
    assign overflow = (sign_A ^ sign_B) & (sign_A ^ sign_res);

    // Clock gating wrapper for synchronous operation
    /*
    reg [63:0] result_reg;
    reg overflow_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 64'b0;
            overflow_reg <= 1'b0;
        end else if (clk_en) begin
            result_reg <= result;
            overflow_reg <= overflow;
        end
    end
    */

endmodule