module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] ext_a_reg;       // Extended multiplicand
reg [size-1:0] b_reg;              // Multiplier bits
reg [2*size-1:0] sum_reg [0:3];    // Accumulation registers
reg [3:0] b_bit_reg;               // Registered multiplier bits for each stage

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        ext_a_reg <= 0;
        b_reg <= 0;
        for (integer i = 0; i < 4; i = i + 1) begin
            sum_reg[i] <= 0;
        end
        b_bit_reg <= 0;
        mul_out <= 0;
    end else begin
        // Stage 0: Register inputs and extend multiplicand
        ext_a_reg <= { {size{1'b0}}, mul_a };
        b_reg <= mul_b;
        b_bit_reg <= mul_b;  // Capture all multiplier bits
        
        // Stage 1: Process bit 0
        sum_reg[0] <= b_bit_reg[0] ? ext_a_reg : 0;
        
        // Stage 2: Process bit 1 (shift left 1)
        sum_reg[1] <= sum_reg[0] + (b_bit_reg[1] ? (ext_a_reg << 1) : 0);
        
        // Stage 3: Process bit 2 (shift left 2)
        sum_reg[2] <= sum_reg[1] + (b_bit_reg[2] ? (ext_a_reg << 2) : 0);
        
        // Stage 4: Process bit 3 (shift left 3) and final output
        sum_reg[3] <= sum_reg[2] + (b_bit_reg[3] ? (ext_a_reg << 3) : 0);
        mul_out <= sum_reg[3];
    end
end

endmodule