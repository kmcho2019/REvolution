module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [31:0] stage1_sum;    // Lower 32-bit sum
reg        stage1_carry;  // Carry out from lower 32 bits
reg [31:0] stage1_a_hi;   // Upper 32 bits of A
reg [31:0] stage1_b_hi;   // Upper 32 bits of B
reg        stage1_valid;  // Pipeline valid flag

// Intermediate signals
wire [32:0] sum_low;      // 33-bit result (32 sum + 1 carry)
wire [32:0] sum_high;     // 33-bit result (32 sum + 1 carry)

// First stage: Lower 32 bits
assign sum_low = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};

// Second stage: Upper 32 bits with carry
assign sum_high = {1'b0, stage1_a_hi} + {1'b0, stage1_b_hi} + {32'b0, stage1_carry};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_sum <= 32'b0;
        stage1_carry <= 1'b0;
        stage1_a_hi <= 32'b0;
        stage1_b_hi <= 32'b0;
        stage1_valid <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1
        stage1_sum <= sum_low[31:0];
        stage1_carry <= sum_low[32];
        stage1_a_hi <= adda[63:32];
        stage1_b_hi <= addb[63:32];
        stage1_valid <= i_en;
        
        // Pipeline stage 2 (output)
        result <= {sum_high[32:0], stage1_sum};
        o_en <= stage1_valid;
    end
end

endmodule