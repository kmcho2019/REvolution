module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Define the pipeline stages
localparam NUM_STAGES = 3;

// Define the registers for the pipeline stages
reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] sum_reg [0:NUM_STAGES-1];

// Define the output enable signal
reg [NUM_STAGES-1:0] o_en_reg;

// Register the input operands
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Perform the addition operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg[0] <= 65'd0;
    end else if (i_en) begin
        sum_reg[0] <= {1'b0, adda_reg} + {1'b0, addb_reg};
    end
end

// Pipeline the result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 1; i < NUM_STAGES; i++) begin
            sum_reg[i] <= 65'd0;
        end
    end else begin
        for (int i = 1; i < NUM_STAGES; i++) begin
            sum_reg[i] <= sum_reg[i-1];
        end
    end
end

// Generate the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_reg <= {NUM_STAGES{1'b0}};
    end else if (i_en) begin
        o_en_reg <= {o_en_reg[NUM_STAGES-2:0], 1'b1};
    end else begin
        o_en_reg <= {o_en_reg[NUM_STAGES-2:0], 1'b0};
    end
end

assign result = sum_reg[NUM_STAGES-1];
assign o_en = o_en_reg[NUM_STAGES-1];

endmodule