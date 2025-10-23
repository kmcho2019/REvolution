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

// Define the input registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;

// Define the output register
reg [64:0] result_reg;

// Define the output enable signal
reg o_en_reg;

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
        wire cin;
        assign cin = (i == 0)? 1'b0 : result_reg[i-1];
        full_adder segment_adder(
          .a(adda_reg[i]),
          .b(addb_reg[i]),
          .cin(cin),
          .sum(result_reg[i]),
          .cout(result_reg[i+1])
        );
    end
endgenerate

// Update the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Assign the output
assign result = result_reg;
assign o_en = o_en_reg;

endmodule