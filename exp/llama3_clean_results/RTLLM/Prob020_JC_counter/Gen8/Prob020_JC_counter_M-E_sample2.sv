module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Define the number of stages for the pipelined implementation
localparam NUM_STAGES = 8;

// Define the width of each stage
localparam STAGE_WIDTH = 64 / NUM_STAGES;

// Internal signals for pipelined stages
reg [STAGE_WIDTH-1:0] stage_data [NUM_STAGES-1:0];

// Always block for the pipelined stages
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all stages
        for (int i = 0; i < NUM_STAGES; i++) begin
            stage_data[i] <= 0;
        end
    end else begin
        // Update each stage
        for (int i = 0; i < NUM_STAGES-1; i++) begin
            // Shift data from previous stage and compute new MSB
            stage_data[i+1] <= {~stage_data[i][0], stage_data[i][STAGE_WIDTH-2:1]};
        end
        
        // Update the first stage (MSB stage) based on the last stage's LSB
        stage_data[0] <= {~stage_data[NUM_STAGES-1][0], stage_data[NUM_STAGES-1][STAGE_WIDTH-2:1]};
    end
end

// Continuous assignment for the output Q
assign Q = {stage_data[NUM_STAGES-1], stage_data[NUM_STAGES-2], stage_data[NUM_STAGES-3], stage_data[NUM_STAGES-4], 
            stage_data[NUM_STAGES-5], stage_data[NUM_STAGES-6], stage_data[NUM_STAGES-7], stage_data[0]};

endmodule