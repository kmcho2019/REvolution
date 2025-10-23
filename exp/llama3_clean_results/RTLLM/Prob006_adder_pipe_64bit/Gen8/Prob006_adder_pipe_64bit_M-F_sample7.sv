// Define the full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the main adder module
module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the number of pipeline stages
parameter STAGES = 4;

// Define the width of each stage
parameter STAGE_WIDTH = 16;

// Define the input registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;

// Define the output register
reg [64:0] result_reg;

// Define the output enable signal
reg o_en_reg;

// Define the pipeline registers
reg [15:0] segment1_sum_reg;
reg [15:0] segment2_sum_reg;
reg [15:0] segment3_sum_reg;
reg [15:0] segment4_sum_reg;

// Define the carry signals
reg [3:0] cout_reg;

// Initialize the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Capture the input data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Define the segment adders
genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin
        full_adder segment_adder(
           .a(adda_reg[i]),
           .b(addb_reg[i]),
           .cin(i == 0? 1'b0 : cout_reg[i-1]),
           .sum(result_reg[i]),
           .cout(cout_reg[i])
        );
    end
endgenerate

// Update the result register
always @(posedge clk) begin
    result_reg[64] <= cout_reg[63];
end

// Assign the output
assign result = result_reg;
assign o_en = o_en_reg;

endmodule