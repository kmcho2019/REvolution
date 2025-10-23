module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Define the number of pipeline stages
localparam NUM_STAGES = 8;

// Define the number of cells per stage
localparam CELLS_PER_STAGE = 512 / NUM_STAGES;

// Define the pipeline registers
reg [CELLS_PER_STAGE-1:0] pipeline_reg [NUM_STAGES-1:0];

// Combinational logic to calculate the next state of each cell
wire [CELLS_PER_STAGE-1:0] next_state [NUM_STAGES-1:0];

genvar i, j;
generate
    for (i = 0; i < NUM_STAGES; i++) begin
        for (j = 0; j < CELLS_PER_STAGE; j++) begin
            wire left, center, right;
            // Simplified boundary conditions
            assign left = (i == 0 && j == 0)? 1'b0 : (i == 0)? q_reg[j-1] : pipeline_reg[i-1][j];
            assign center = (i == 0)? q_reg[j] : pipeline_reg[i-1][j];
            assign right = (i == NUM_STAGES-1 && j == CELLS_PER_STAGE-1)? 1'b0 : (i == NUM_STAGES-1)? 1'b0 : pipeline_reg[i][j+1];
            
            // Apply Rule 90 logic directly without needing additional variables
            assign next_state[i][j] = (left == 1 && center == 1 && right == 1) ? 1'b0 :
                                       (left == 1 && center == 1 && right == 0) ? 1'b1 :
                                       (left == 1 && center == 0 && right == 1) ? 1'b0 :
                                       (left == 1 && center == 0 && right == 0) ? 1'b1 :
                                       (left == 0 && center == 1 && right == 1) ? 1'b1 :
                                       (left == 0 && center == 1 && right == 0) ? 1'b0 :
                                       (left == 0 && center == 0 && right == 1) ? 1'b1 :
                                       (left == 0 && center == 0 && right == 0) ? 1'b0 : 1'b0;
        end
    end
endgenerate

// Sequential logic to update pipeline registers
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        for (int i = 0; i < NUM_STAGES; i++) begin
            pipeline_reg[i] <= (i == 0)? data[CELLS_PER_STAGE-1:0] : (i == NUM_STAGES-1)? data[511:512-CELLS_PER_STAGE] : data[(i*CELLS_PER_STAGE)+CELLS_PER_STAGE-1:(i*CELLS_PER_STAGE)];
        end
    end else begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            if (i == 0) begin
                pipeline_reg[i] <= next_state[i];
            end else begin
                pipeline_reg[i] <= next_state[i];
            end
        end
        q_reg <= (next_state[NUM_STAGES-1]);
    end
end

assign q = q_reg;

endmodule