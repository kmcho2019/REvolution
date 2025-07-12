module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output wire o_en
);

parameter STG_WIDTH = 16;
parameter NUM_STAGES = 4;

// Pipeline registers for operands
reg [STG_WIDTH-1:0] adda_pipe [0:NUM_STAGES-1];
reg [STG_WIDTH-1:0] addb_pipe [0:NUM_STAGES-1];

// Pipeline registers for carries
reg carry_pipe [0:NUM_STAGES-2];  // One less than NUM_STAGES

// Sum outputs for each stage
wire [STG_WIDTH:0] sum [0:NUM_STAGES-1];

// Enable pipeline (shift register)
reg [NUM_STAGES-1:0] en_pipe = 0;

// Continuous assignments for sums
assign sum[0] = adda_pipe[0] + addb_pipe[0];
assign sum[1] = {1'b0, adda_pipe[1]} + {1'b0, addb_pipe[1]} + carry_pipe[0];
assign sum[2] = {1'b0, adda_pipe[2]} + {1'b0, addb_pipe[2]} + carry_pipe[1];
assign sum[3] = {1'b0, adda_pipe[3]} + {1'b0, addb_pipe[3]} + carry_pipe[2];

// Final result assembly
assign result = {sum[3][STG_WIDTH-1:0], sum[2][STG_WIDTH-1:0], 
                sum[1][STG_WIDTH-1:0], sum[0][STG_WIDTH-1:0]};
assign o_en = en_pipe[NUM_STAGES-1];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer i = 0; i < NUM_STAGES; i = i + 1) begin
            adda_pipe[i] <= 0;
            addb_pipe[i] <= 0;
            if (i < NUM_STAGES-1) carry_pipe[i] <= 0;
        end
        en_pipe <= 0;
    end else begin
        // Stage 0: bits [15:0]
        adda_pipe[0] <= adda[STG_WIDTH-1:0];
        addb_pipe[0] <= addb[STG_WIDTH-1:0];
        
        // Stage 1: bits [31:16]
        adda_pipe[1] <= adda[2*STG_WIDTH-1:STG_WIDTH];
        addb_pipe[1] <= addb[2*STG_WIDTH-1:STG_WIDTH];
        carry_pipe[0] <= sum[0][STG_WIDTH];
        
        // Stage 2: bits [47:32]
        adda_pipe[2] <= adda[3*STG_WIDTH-1:2*STG_WIDTH];
        addb_pipe[2] <= addb[3*STG_WIDTH-1:2*STG_WIDTH];
        carry_pipe[1] <= sum[1][STG_WIDTH];
        
        // Stage 3: bits [63:48]
        adda_pipe[3] <= adda[4*STG_WIDTH-1:3*STG_WIDTH];
        addb_pipe[3] <= addb[4*STG_WIDTH-1:3*STG_WIDTH];
        carry_pipe[2] <= sum[2][STG_WIDTH];
        
        // Enable pipeline
        en_pipe <= {en_pipe[NUM_STAGES-2:0], i_en};
    end
end

endmodule