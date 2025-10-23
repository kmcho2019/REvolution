module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define the number of pipeline stages
parameter PIPELINE_DEPTH = 8;

// Define the number of bits per stage
parameter BITS_PER_STAGE = 8;

// Define the total number of bits
parameter TOTAL_BITS = 64;

// Initialize the internal signals
reg [TOTAL_BITS-1:0] adda_reg;
reg [TOTAL_BITS-1:0] addb_reg;
reg [TOTAL_BITS:0] result_reg;
reg o_en_reg;

// Initialize the carry signals
reg [PIPELINE_DEPTH-1:0] carry_in;
reg [PIPELINE_DEPTH-1:0] carry_out;

// Initialize the pipeline registers
reg [TOTAL_BITS-1:0] pipeline_reg [PIPELINE_DEPTH-1:0];

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 1'b0;
    end
end

// Carry-select adder
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        carry_in <= {PIPELINE_DEPTH{1'b0}};
        carry_out <= {PIPELINE_DEPTH{1'b0}};
    end else begin
        for (int i = 0; i < PIPELINE_DEPTH; i++) begin
            if (i == 0) begin
                // First stage, no carry-in
                carry_out[i] <= (adda_reg[BITS_PER_STAGE-1:0] + addb_reg[BITS_PER_STAGE-1:0]) > (1 << BITS_PER_STAGE) - 1;
            end else begin
                // Subsequent stages, use carry-in from previous stage
                carry_out[i] <= (adda_reg[(i+1)*BITS_PER_STAGE-1:i*BITS_PER_STAGE] + addb_reg[(i+1)*BITS_PER_STAGE-1:i*BITS_PER_STAGE] + carry_in[i-1]) > (1 << BITS_PER_STAGE) - 1;
            end
            // Update carry-in for next stage
            carry_in[i] <= carry_out[i];
        end
    end
end

// Pipeline registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < PIPELINE_DEPTH; i++) begin
            pipeline_reg[i] <= 64'd0;
        end
    end else begin
        for (int i = 0; i < PIPELINE_DEPTH-1; i++) begin
            pipeline_reg[i] <= {carry_out[i], adda_reg[(i+1)*BITS_PER_STAGE-1:i*BITS_PER_STAGE] + addb_reg[(i+1)*BITS_PER_STAGE-1:i*BITS_PER_STAGE]};
        end
        pipeline_reg[PIPELINE_DEPTH-1] <= {carry_out[PIPELINE_DEPTH-1], adda_reg[(PIPELINE_DEPTH)*BITS_PER_STAGE-1:(PIPELINE_DEPTH-1)*BITS_PER_STAGE] + addb_reg[(PIPELINE_DEPTH)*BITS_PER_STAGE-1:(PIPELINE_DEPTH-1)*BITS_PER_STAGE]};
    end
end

// Result calculation and output enable logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        result_reg <= {carry_out[PIPELINE_DEPTH-1], pipeline_reg[PIPELINE_DEPTH-1]};
        if (carry_out[PIPELINE_DEPTH-1]) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule