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

// Define the segment adders
wire [15:0] segment1_sum;
wire segment1_cout;
wire [15:0] segment2_sum;
wire segment2_cout;
wire [15:0] segment3_sum;
wire segment3_cout;
wire [15:0] segment4_sum;
wire segment4_cout;

// Define the carry chain
wire [3:0] carry_chain;

// Define the pipeline registers
reg [15:0] segment1_sum_reg;
reg [15:0] segment2_sum_reg;
reg [15:0] segment3_sum_reg;
reg [15:0] segment4_sum_reg;

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
full_adder segment1_adder(
    .a(adda_reg[15:0]),
    .b(addb_reg[15:0]),
    .cin(1'b0),
    .sum(segment1_sum),
    .cout(segment1_cout)
);

full_adder segment2_adder(
    .a(adda_reg[31:16]),
    .b(addb_reg[31:16]),
    .cin(segment1_cout),
    .sum(segment2_sum),
    .cout(segment2_cout)
);

full_adder segment3_adder(
    .a(adda_reg[47:32]),
    .b(addb_reg[47:32]),
    .cin(segment2_cout),
    .sum(segment3_sum),
    .cout(segment3_cout)
);

full_adder segment4_adder(
    .a(adda_reg[63:48]),
    .b(addb_reg[63:48]),
    .cin(segment3_cout),
    .sum(segment4_sum),
    .cout(segment4_cout)
);

// Define the carry chain
assign carry_chain[0] = segment1_cout;
assign carry_chain[1] = segment2_cout;
assign carry_chain[2] = segment3_cout;
assign carry_chain[3] = segment4_cout;

// Define the pipeline registers
always @(posedge clk) begin
    segment1_sum_reg <= segment1_sum;
    segment2_sum_reg <= segment2_sum;
    segment3_sum_reg <= segment3_sum;
    segment4_sum_reg <= segment4_sum;
end

// Assign the result
always @(posedge clk) begin
    if (i_en) begin
        result_reg <= {segment4_cout, segment4_sum_reg, segment3_sum_reg, segment2_sum_reg, segment1_sum_reg};
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

// Define the full adder module
module full_adder(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);

assign sum = a + b + cin;
assign cout = (a[15] & b[15]) | (a[15] & cin) | (b[15] & cin);

endmodule

endmodule