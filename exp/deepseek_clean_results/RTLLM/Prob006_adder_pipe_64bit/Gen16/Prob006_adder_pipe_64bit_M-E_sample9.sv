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
reg [47:0] stage1_sum;    // Lower 48-bit sum
reg        stage1_carry;  // Carry out from lower 48 bits
reg [15:0] stage1_a_hi;   // Upper 16 bits of A
reg [15:0] stage1_b_hi;   // Upper 16 bits of B
reg        stage1_valid;  // Pipeline valid flag

// Intermediate signals
wire [47:0] sum_low;
wire [15:0] sum_high;
wire        carry_low;
wire        carry_high;

// First stage: Lower 48 bits (3x16 with carry-skip)
assign {carry_low, sum_low} = 
    {1'b0, adda[15:0]} + {1'b0, addb[15:0]} + 
    {48'b0, adda[31:16]} + {48'b0, addb[31:16]} + 
    {48'b0, adda[47:32]} + {48'b0, addb[47:32]};

// Second stage: Upper 16 bits
assign {carry_high, sum_high} = 
    {1'b0, stage1_a_hi} + {1'b0, stage1_b_hi} + {16'b0, stage1_carry};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_sum <= 48'b0;
        stage1_carry <= 1'b0;
        stage1_a_hi <= 16'b0;
        stage1_b_hi <= 16'b0;
        stage1_valid <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1
        stage1_sum <= sum_low;
        stage1_carry <= carry_low;
        stage1_a_hi <= adda[63:48];
        stage1_b_hi <= addb[63:48];
        stage1_valid <= i_en;
        
        // Pipeline stage 2 (output)
        result <= {carry_high, sum_high, stage1_sum};
        o_en <= stage1_valid;
    end
end

endmodule