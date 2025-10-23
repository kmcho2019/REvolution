module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;
localparam PIPELINE_DEPTH = NUM_STAGES;

// Pipeline registers - only store relevant bits per stage
reg [STG_WIDTH-1:0] a_pipe [0:NUM_STAGES-1];
reg [STG_WIDTH-1:0] b_pipe [0:NUM_STAGES-1];
reg [NUM_STAGES:0] carry_pipe;
reg [PIPELINE_DEPTH:0] en_pipe;

// Stage outputs
wire [STG_WIDTH:0] stage_sum [0:NUM_STAGES-1];

// Generate all stages
genvar i;
generate
    for (i = 0; i < NUM_STAGES; i = i + 1) begin : STAGES
        // Compute stage sum with carry in
        assign stage_sum[i] = {1'b0, a_pipe[i]} + {1'b0, b_pipe[i]} + carry_pipe[i];
    end
endgenerate

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        for (int j = 0; j < NUM_STAGES; j = j + 1) begin
            a_pipe[j] <= '0;
            b_pipe[j] <= '0;
        end
        carry_pipe <= '0;
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[PIPELINE_DEPTH-1:0], i_en};
        
        // First pipeline stage - register inputs
        a_pipe[0] <= adda[0 +: STG_WIDTH];
        b_pipe[0] <= addb[0 +: STG_WIDTH];
        carry_pipe[0] <= 1'b0;
        
        // Intermediate pipeline stages
        for (int j = 1; j < NUM_STAGES; j = j + 1) begin
            a_pipe[j] <= adda[j*STG_WIDTH +: STG_WIDTH];
            b_pipe[j] <= addb[j*STG_WIDTH +: STG_WIDTH];
            carry_pipe[j] <= stage_sum[j-1][STG_WIDTH];
        end
        
        // Final pipeline stage - assemble result
        if (en_pipe[PIPELINE_DEPTH]) begin
            result[DATA_WIDTH] <= carry_pipe[NUM_STAGES];
            
            // Combine all stage results
            for (int j = 0; j < NUM_STAGES; j = j + 1) begin
                result[j*STG_WIDTH +: STG_WIDTH] <= stage_sum[j][STG_WIDTH-1:0];
            end
            
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule