module adder_pipe_64bit #(
    parameter STAGES = 8
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define the width of each stage
localparam STAGE_WIDTH = 8;

// Define the number of stages
localparam NUM_STAGES = STAGES;

// Registers for input operands
reg [63:0] adda_reg;
reg [63:0] addb_reg;

// Register for output enable signal
reg o_en_reg;

// Output result register
reg [64:0] result_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {64{1'b0}};
        addb_reg <= {64{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 1'b0;
    end
end

// Pipeline stages
reg [NUM_STAGES-1:0][STAGE_WIDTH-1:0] partial_sums;
reg [NUM_STAGES-1:0] carries;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_sums <= {NUM_STAGES{STAGE_WIDTH{1'b0}}};
        carries <= {NUM_STAGES{1'b0}};
    end else begin
        // First stage
        partial_sums[0] <= adda_reg[7:0] + addb_reg[7:0];
        carries[0] <= (adda_reg[7:0] + addb_reg[7:0]) > {STAGE_WIDTH{1'b1}} - 1;

        // Remaining stages
        for (int i = 1; i < NUM_STAGES; i++) begin
            partial_sums[i] <= adda_reg[(i*STAGE_WIDTH)+7:(i*STAGE_WIDTH)] + addb_reg[(i*STAGE_WIDTH)+7:(i*STAGE_WIDTH)] + carries[i-1];
            carries[i] <= (adda_reg[(i*STAGE_WIDTH)+7:(i*STAGE_WIDTH)] + addb_reg[(i*STAGE_WIDTH)+7:(i*STAGE_WIDTH)] + carries[i-1]) > {STAGE_WIDTH{1'b1}} - 1;
        end
    end
end

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {65{1'b0}};
        o_en_reg <= 1'b0;
    end else begin
        // Concatenate partial sums and carry
        result_reg <= {carries[NUM_STAGES-1], partial_sums[NUM_STAGES-1], partial_sums[NUM_STAGES-2], partial_sums[NUM_STAGES-3], partial_sums[NUM_STAGES-4], partial_sums[NUM_STAGES-5], partial_sums[NUM_STAGES-6], partial_sums[NUM_STAGES-7], partial_sums[0]};
        if (i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule