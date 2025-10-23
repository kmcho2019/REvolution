module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Segment parameters
localparam SEG_WIDTH = 8;
localparam NUM_SEG = 8;

// Pipeline stage registers
reg [63:0] a_stage1, b_stage1;
reg [63:0] a_stage2, b_stage2;

// Precomputed sums (carry=0 and carry=1)
wire [SEG_WIDTH-1:0] sum0_0 [0:NUM_SEG-1];
wire [SEG_WIDTH-1:0] sum0_1 [0:NUM_SEG-1];
reg [SEG_WIDTH-1:0] sum0_0_reg [0:NUM_SEG-1];
reg [SEG_WIDTH-1:0] sum0_1_reg [0:NUM_SEG-1];

// Carry signals
wire [NUM_SEG:0] carry;
reg [NUM_SEG:0] carry_reg;

// Selected sums
wire [SEG_WIDTH-1:0] final_sum [0:NUM_SEG-1];
reg [SEG_WIDTH-1:0] final_sum_reg [0:NUM_SEG-1];

// Pipeline enable signals
reg en_stage1, en_stage2, en_stage3;

// Stage 1: Precompute sums with carry=0 and carry=1 for each segment
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEG_PRECOMP
        assign sum0_0[i] = adda[i*SEG_WIDTH +: SEG_WIDTH] + addb[i*SEG_WIDTH +: SEG_WIDTH];
        assign sum0_1[i] = adda[i*SEG_WIDTH +: SEG_WIDTH] + addb[i*SEG_WIDTH +: SEG_WIDTH] + 1'b1;
    end
endgenerate

// Stage 2: Carry propagation and sum selection
assign carry[0] = 1'b0;  // Initial carry-in

generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : CARRY_SELECT
        assign carry[i+1] = (a_stage1[i*SEG_WIDTH +: SEG_WIDTH] & b_stage1[i*SEG_WIDTH +: SEG_WIDTH]) | 
                          ((a_stage1[i*SEG_WIDTH +: SEG_WIDTH] | b_stage1[i*SEG_WIDTH +: SEG_WIDTH]) & carry[i];
        assign final_sum[i] = carry[i] ? sum0_1_reg[i] : sum0_0_reg[i];
    end
endgenerate

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_stage1 <= 64'b0; b_stage1 <= 64'b0;
        a_stage2 <= 64'b0; b_stage2 <= 64'b0;
        
        for (integer j = 0; j < NUM_SEG; j = j + 1) begin
            sum0_0_reg[j] <= {SEG_WIDTH{1'b0}};
            sum0_1_reg[j] <= {SEG_WIDTH{1'b0}};
            final_sum_reg[j] <= {SEG_WIDTH{1'b0}};
        end
        
        carry_reg <= {(NUM_SEG+1){1'b0}};
        en_stage1 <= 1'b0; en_stage2 <= 1'b0; en_stage3 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1
        a_stage1 <= adda;
        b_stage1 <= addb;
        for (integer j = 0; j < NUM_SEG; j = j + 1) begin
            sum0_0_reg[j] <= sum0_0[j];
            sum0_1_reg[j] <= sum0_1[j];
        end
        en_stage1 <= i_en;
        
        // Pipeline stage 2
        a_stage2 <= a_stage1;
        b_stage2 <= b_stage1;
        carry_reg <= carry;
        en_stage2 <= en_stage1;
        
        // Pipeline stage 3
        for (integer j = 0; j < NUM_SEG; j = j + 1) begin
            final_sum_reg[j] <= final_sum[j];
        end
        en_stage3 <= en_stage2;
        
        // Final output
        if (en_stage3) begin
            result <= {carry_reg[NUM_SEG], 
                      final_sum_reg[7], final_sum_reg[6], final_sum_reg[5], final_sum_reg[4],
                      final_sum_reg[3], final_sum_reg[2], final_sum_reg[1], final_sum_reg[0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule