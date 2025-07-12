module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

// Define the number of pipeline stages
localparam NUM_STAGES = 4;

// Define the size of each segment
localparam SEGMENT_SIZE = 512 / NUM_STAGES;

reg [511:0] q_reg;
reg [511:0] pipe_reg [NUM_STAGES - 1:0];

// Combinational logic to calculate the next state of each cell
genvar i, j;
generate
    for (i = 0; i < NUM_STAGES; i++) begin
        for (j = 0; j < SEGMENT_SIZE; j++) begin
            wire left, right;
            // Calculate the index of the current cell
            wire [9:0] index = i * SEGMENT_SIZE + j;
            
            // Explicit boundary conditions for clarity and potential synthesis optimization
            assign left = (index == 0) ? 1'b0 : (i == 0) ? q_reg[index - 1] : pipe_reg[i - 1][index - 1];
            assign right = (index == 511) ? 1'b0 : (i == NUM_STAGES - 1) ? 1'b0 : pipe_reg[i][index + 1];
            
            // Apply Rule 90 logic directly without needing additional variables
            assign pipe_reg[i][index] = left ^ right;
        end
    end
endgenerate

// Sequential logic to update q_reg and pipeline registers on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        for (int i = 0; i < NUM_STAGES - 1; i++) begin
            pipe_reg[i] <= {SEGMENT_SIZE{1'b0}};
        end
    end else begin
        // Update pipeline registers
        for (int i = 1; i < NUM_STAGES; i++) begin
            pipe_reg[i - 1] <= pipe_reg[i];
        end
        // Update q_reg with the final stage of the pipeline
        q_reg <= pipe_reg[NUM_STAGES - 1];
    end
end

assign q = q_reg;

endmodule