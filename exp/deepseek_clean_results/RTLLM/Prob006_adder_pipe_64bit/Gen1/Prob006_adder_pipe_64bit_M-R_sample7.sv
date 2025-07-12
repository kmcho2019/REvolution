module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

parameter STG_WIDTH = 16;  // Bits per pipeline stage
parameter NUM_STAGES = 4;  // Number of pipeline stages

// Pipeline registers for operands
reg [STG_WIDTH-1:0] adda_pipe [0:NUM_STAGES-1];
reg [STG_WIDTH-1:0] addb_pipe [0:NUM_STAGES-1];

// Pipeline registers for partial sums and carries
reg [STG_WIDTH:0] sum_pipe [0:NUM_STAGES-1];
reg carry_pipe [0:NUM_STAGES-2];  // One less than NUM_STAGES

// Enable signal pipeline
reg en_pipe [0:NUM_STAGES-1];

// Combinational additions for each stage
wire [STG_WIDTH:0] stage_sum [0:NUM_STAGES-1];

// Stage 0 addition (no carry in)
assign stage_sum[0] = {1'b0, adda[STG_WIDTH-1:0]} + {1'b0, addb[STG_WIDTH-1:0]};

// Subsequent stages with carry in
genvar i;
generate
    for (i = 1; i < NUM_STAGES; i = i + 1) begin : stage_adders
        assign stage_sum[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + carry_pipe[i-1];
    end
endgenerate

// Pipeline processing
integer j;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (j = 0; j < NUM_STAGES; j = j + 1) begin
            adda_pipe[j] <= {STG_WIDTH{1'b0}};
            addb_pipe[j] <= {STG_WIDTH{1'b0}};
            sum_pipe[j] <= {(STG_WIDTH+1){1'b0}};
            en_pipe[j] <= 1'b0;
        end
        
        for (j = 0; j < NUM_STAGES-1; j = j + 1) begin
            carry_pipe[j] <= 1'b0;
        end
        
        result <= {65{1'b0}};
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input sampling
        adda_pipe[0] <= adda[STG_WIDTH-1:0];
        addb_pipe[0] <= addb[STG_WIDTH-1:0];
        sum_pipe[0] <= stage_sum[0];
        en_pipe[0] <= i_en;
        
        // Subsequent stages
        for (j = 1; j < NUM_STAGES; j = j + 1) begin
            // Operand sampling (next 16-bit chunk)
            adda_pipe[j] <= adda[(j+1)*STG_WIDTH-1:j*STG_WIDTH];
            addb_pipe[j] <= addb[(j+1)*STG_WIDTH-1:j*STG_WIDTH];
            
            // Sum and carry propagation
            sum_pipe[j] <= stage_sum[j];
            carry_pipe[j-1] <= sum_pipe[j-1][STG_WIDTH];
            
            // Enable propagation
            en_pipe[j] <= en_pipe[j-1];
        end
        
        // Final result assembly
        result <= {sum_pipe[3][STG_WIDTH-1:0], 
                  sum_pipe[2][STG_WIDTH-1:0], 
                  sum_pipe[1][STG_WIDTH-1:0], 
                  sum_pipe[0][STG_WIDTH-1:0]};
        o_en <= en_pipe[NUM_STAGES-1];
    end
end

endmodule