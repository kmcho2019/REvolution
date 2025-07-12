module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] next_state_reg;

// Define the number of pipeline stages
localparam NUM_STAGES = 8;

// Define the number of cells per stage
localparam CELLS_PER_STAGE = 512 / NUM_STAGES;

// Define the pipeline registers
reg [NUM_STAGES-1:0][CELLS_PER_STAGE-1:0] pipeline_regs;

// Combinational logic to calculate the next state of each cell
genvar i;
generate
    for (i = 0; i < NUM_STAGES; i++) begin
        // Calculate the start and end indices of the current stage
        localparam START_IDX = i * CELLS_PER_STAGE;
        localparam END_IDX = (i + 1) * CELLS_PER_STAGE - 1;

        // Generate the combinational logic for the current stage
        for (genvar j = 0; j < CELLS_PER_STAGE; j++) begin
            wire left, center, right;
            assign left = (START_IDX + j == 0)? 1'b0 : q_reg[START_IDX + j - 1];
            assign center = q_reg[START_IDX + j];
            assign right = (START_IDX + j == 511)? 1'b0 : q_reg[START_IDX + j + 1];

            // Apply Rule 90 logic
            assign pipeline_regs[i][j] = (left == 1 && center == 1 && right == 1)? 1'b0 :
                                           (left == 1 && center == 1 && right == 0)? 1'b1 :
                                           (left == 1 && center == 0 && right == 1)? 1'b0 :
                                           (left == 1 && center == 0 && right == 0)? 1'b1 :
                                           (left == 0 && center == 1 && right == 1)? 1'b1 :
                                           (left == 0 && center == 1 && right == 0)? 1'b0 :
                                           (left == 0 && center == 0 && right == 1)? 1'b1 :
                                           (left == 0 && center == 0 && right == 0)? 1'b0 : 1'b0;
        end
    end
endgenerate

// Pipeline logic to update the pipeline registers
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        for (int i = 0; i < NUM_STAGES; i++) begin
            pipeline_regs[i] <= {CELLS_PER_STAGE{1'b0}};
        end
    end else begin
        for (int i = 0; i < NUM_STAGES - 1; i++) begin
            pipeline_regs[i] <= pipeline_regs[i + 1];
        end
        pipeline_regs[NUM_STAGES - 1] <= next_state_reg;
        q_reg <= pipeline_regs[0];
    end
end

// Combinational logic to calculate the next state of each cell
assign next_state_reg = {>>{pipeline_regs[NUM_STAGES - 1]}};

assign q = q_reg;

endmodule