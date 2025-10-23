module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline parameters
localparam STAGES = 4;
localparam BITS_PER_STAGE = 16;

// Pipeline registers
reg [BITS_PER_STAGE-1:0] a_reg [0:STAGES-1];
reg [BITS_PER_STAGE-1:0] b_reg [0:STAGES-1];
reg [STAGES-2:0] carry_in_reg;  // Carry between stages
reg [STAGES-1:0] en_reg;        // Enable pipeline

// Carry-select computation wires
wire [BITS_PER_STAGE:0] sum0 [0:STAGES-1];  // Sum assuming carry=0
wire [BITS_PER_STAGE:0] sum1 [0:STAGES-1];  // Sum assuming carry=1
wire [BITS_PER_STAGE:0] stage_sum [0:STAGES-1]; // Final selected sum

// Generate all pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : pipeline_stages
        // Compute both possible sums for each stage
        assign sum0[i] = {1'b0, a_reg[i]} + {1'b0, b_reg[i]};
        assign sum1[i] = {1'b0, a_reg[i]} + {1'b0, b_reg[i]} + 1'b1;
        
        // Select correct sum based on carry from previous stage
        if (i == 0) begin
            // First stage has no carry input
            assign stage_sum[i] = sum0[i];
        end else begin
            assign stage_sum[i] = carry_in_reg[i-1] ? sum1[i] : sum0[i];
        end
    end
endgenerate

// Pipeline update logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < STAGES; j = j + 1) begin
            a_reg[j] <= 0;
            b_reg[j] <= 0;
        end
        carry_in_reg <= 0;
        en_reg <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0 input registers (bits 15:0)
        a_reg[0] <= adda[15:0];
        b_reg[0] <= addb[15:0];
        
        // Stage 1 input registers (bits 31:16)
        a_reg[1] <= adda[31:16];
        b_reg[1] <= addb[31:16];
        
        // Stage 2 input registers (bits 47:32)
        a_reg[2] <= adda[47:32];
        b_reg[2] <= addb[47:32];
        
        // Stage 3 input registers (bits 63:48)
        a_reg[3] <= adda[63:48];
        b_reg[3] <= addb[63:48];
        
        // Carry propagation between stages
        carry_in_reg[0] <= stage_sum[0][BITS_PER_STAGE];
        carry_in_reg[1] <= stage_sum[1][BITS_PER_STAGE];
        carry_in_reg[2] <= stage_sum[2][BITS_PER_STAGE];
        
        // Enable signal pipeline
        en_reg <= {en_reg[STAGES-2:0], i_en};
        
        // Final result assembly
        result <= {stage_sum[3], stage_sum[2][BITS_PER_STAGE-1:0],
                  stage_sum[1][BITS_PER_STAGE-1:0], stage_sum[0][BITS_PER_STAGE-1:0]};
        
        // Output enable (valid when last stage completes)
        o_en <= en_reg[STAGES-1];
    end
end

endmodule