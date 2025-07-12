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
reg [7:0] mul_a_reg, mul_b_reg;
reg [1:0] en_pipeline;
wire [15:0] booth_pp [3:0];  // Booth encoded partial products
wire [15:0] csa_sum, csa_carry;

// Booth encoder (radix-4)
function [15:0] booth_encoder;
    input [7:0] a;
    input [2:0] b_group;
    reg [1:0] sel;
    reg neg;
begin
    case (b_group)
        3'b000, 3'b111: sel = 2'b00;  // 0
        3'b001, 3'b010: sel = 2'b01;  // +1
        3'b011:         sel = 2'b10;  // +2
        3'b100:         sel = 2'b10;  // -2
        3'b101, 3'b110: sel = 2'b11;  // -1
    endcase
    
    neg = b_group[2];  // Negative flag
    
    booth_encoder = (sel == 2'b00) ? 16'b0 : 
                   ((sel == 2'b01) ? {8'b0, a} : 
                   {7'b0, a, 1'b0}) ^ {16{neg}};
end
endfunction

// Generate Booth encoded partial products
assign booth_pp[0] = booth_encoder(mul_a_reg, {mul_b_reg[1:0], 1'b0});
assign booth_pp[1] = booth_encoder(mul_a_reg, mul_b_reg[3:1]) << 2;
assign booth_pp[2] = booth_encoder(mul_a_reg, mul_b_reg[5:3]) << 4;
assign booth_pp[3] = booth_encoder(mul_a_reg, mul_b_reg[7:5]) << 6;

// (4:2) compressor stage
assign csa_sum = booth_pp[0] ^ booth_pp[1] ^ booth_pp[2] ^ booth_pp[3];
assign csa_carry = ((booth_pp[0] & booth_pp[1]) | 
                  ((booth_pp[0] | booth_pp[1]) & booth_pp[2])) << 1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_pipeline <= 2'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Register inputs
        en_pipeline <= {en_pipeline[0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 2: CSA results (registered)
        // Pipeline stage 3: Final addition
        mul_out <= csa_sum + csa_carry;
        mul_en_out <= en_pipeline[1];
    end
end

endmodule