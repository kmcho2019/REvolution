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
    output reg o_en
);

// Define the output register
reg [64:0] result_reg;
reg [63:0] adda_reg;
reg [63:0] addb_reg;

// Initialize the output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

// Define the segment adders
wire [63:0] sum;
wire [63:0] cout;

full_adder fa0(
   .a(adda_reg[0]),
   .b(addb_reg[0]),
   .cin(1'b0),
   .sum(sum[0]),
   .cout(cout[0])
);

generate
    for (genvar i = 1; i < 64; i = i + 1) begin
        full_adder fa(
           .a(adda_reg[i]),
           .b(addb_reg[i]),
           .cin(cout[i-1]),
           .sum(sum[i]),
           .cout(cout[i])
        );
    end
endgenerate

// Update the result register
always @(posedge clk) begin
    result_reg[63:0] <= sum;
    result_reg[64] <= cout[63];
end

// Assign the output
assign result = result_reg;

endmodule