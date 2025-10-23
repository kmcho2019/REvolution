module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define the number of stages in the pipeline
localparam NUM_STAGES = 8;

// Define the width of each stage
localparam STAGE_WIDTH = 8;

// Define the total width of the operands
localparam TOTAL_WIDTH = 64;

// Define the width of the result
localparam RESULT_WIDTH = 65;

// Define the pipeline registers for the input operands
reg [TOTAL_WIDTH-1:0] adda_reg [NUM_STAGES-1:0];
reg [TOTAL_WIDTH-1:0] addb_reg [NUM_STAGES-1:0];

// Define the pipeline registers for the output result
reg [RESULT_WIDTH-1:0] result_reg [NUM_STAGES-1:0];

// Define the pipeline register for the output enable signal
reg [NUM_STAGES-1:0] o_en_reg;

// Initialize the pipeline registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            adda_reg[i] <= {TOTAL_WIDTH{1'b0}};
            addb_reg[i] <= {TOTAL_WIDTH{1'b0}};
            result_reg[i] <= {RESULT_WIDTH{1'b0}};
            o_en_reg[i] <= 1'b0;
        end
    end else begin
        // Shift the input operands through the pipeline
        for (int i = 1; i < NUM_STAGES; i++) begin
            adda_reg[i] <= adda_reg[i-1];
            addb_reg[i] <= addb_reg[i-1];
        end
        adda_reg[0] <= i_en ? adda : {TOTAL_WIDTH{1'b0}};
        addb_reg[0] <= i_en ? addb : {TOTAL_WIDTH{1'b0}};

        // Compute the result for each stage
        for (int i = 0; i < NUM_STAGES; i++) begin
            wire [STAGE_WIDTH-1:0] sum;
            wire carry;
            assign sum = adda_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH] + addb_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH];
            assign carry = (adda_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH] & addb_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH]) | ((adda_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH] ^ addb_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH]) & (adda_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH] | addb_reg[i][STAGE_WIDTH*i +: STAGE_WIDTH]));
            result_reg[i] <= {carry, sum};
        end

        // Shift the output enable signal through the pipeline
        for (int i = 1; i < NUM_STAGES; i++) begin
            o_en_reg[i] <= o_en_reg[i-1];
        end
        o_en_reg[0] <= i_en;
    end
end

// Assign the output result
assign result = result_reg[NUM_STAGES-1];

// Assign the output enable signal
assign o_en = o_en_reg[NUM_STAGES-1];

endmodule