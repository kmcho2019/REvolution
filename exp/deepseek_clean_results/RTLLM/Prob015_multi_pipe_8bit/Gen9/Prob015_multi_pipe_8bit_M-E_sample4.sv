module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline registers
reg [7:0] a_reg, b_reg;
reg en_stage1, en_stage2;
wire [8:0] booth_pp [4:0]; // 5 partial products (9 bits each with sign)
wire [15:0] pp_ext [4:0];  // Sign-extended partial products
wire [15:0] csa_sum, csa_carry;
wire [15:0] final_sum;

// Booth encoder (radix-4)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        en_stage1 <= 1'b0;
        en_stage2 <= 1'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        // Stage 1: Input sampling and Booth encoding
        en_stage1 <= mul_en_in;
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // Stage 2: Accumulation
        en_stage2 <= en_stage1;
        mul_en_out <= en_stage2;
        
        // Final output
        if (en_stage2) begin
            mul_out <= final_sum;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

// Booth encoding and partial product generation
genvar i;
generate
    // Generate booth encoded partial products
    for (i = 0; i < 5; i = i + 1) begin : booth_enc
        wire [2:0] booth_sel;
        wire neg, zero, pos;
        
        // Booth encoder (radix-4)
        assign booth_sel = (i == 0) ? {b_reg[1:0], 1'b0} : 
                          b_reg[2*i+1:2*i-1];
        
        assign neg  = (booth_sel == 3'b100) | (booth_sel == 3'b101) | 
                     (booth_sel == 3'b110);
        assign zero = (booth_sel == 3'b000) | (booth_sel == 3'b111);
        assign pos  = (booth_sel == 3'b001) | (booth_sel == 3'b010) | 
                     (booth_sel == 3'b011);
        
        assign booth_pp[i] = ({9{neg}} & (~{1'b0, a_reg})) + 
                           ({9{pos}} & {1'b0, a_reg}) + 
                           {9{neg}}; // Two's complement adjustment
        
        // Sign extension and shifting
        assign pp_ext[i] = $signed(booth_pp[i]) << (2*i);
    end
endgenerate

// Carry-save adder tree (3:2 compressors)
// First level
wire [15:0] csa1_sum, csa1_carry;
assign {csa1_carry, csa1_sum} = pp_ext[0] + pp_ext[1] + pp_ext[2];

// Second level
assign {csa_carry, csa_sum} = csa1_sum + csa1_carry + pp_ext[3] + pp_ext[4];

// Final carry-propagate adder
assign final_sum = csa_sum + csa_carry;

endmodule