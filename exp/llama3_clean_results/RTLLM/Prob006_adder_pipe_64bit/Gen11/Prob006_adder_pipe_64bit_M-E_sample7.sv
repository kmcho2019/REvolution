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

// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum,
    output cout
);

wire [7:0] cout_int;

full_adder fa0(
   .a(a[0]),
   .b(b[0]),
   .cin(1'b0),
   .sum(sum[0]),
   .cout(cout_int[0])
);

generate
    for (genvar i = 1; i < 8; i = i + 1) begin
        full_adder fa(
           .a(a[i]),
           .b(b[i]),
           .cin(cout_int[i-1]),
           .sum(sum[i]),
           .cout(cout_int[i])
        );
    end
endgenerate

assign cout = cout_int[7];

endmodule

// Define the 64-bit adder module with pipeline stages
module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Define the registers for the pipeline stages
reg [7:0] adda_reg0;
reg [7:0] addb_reg0;
reg [7:0] sum_reg0;
reg cout_reg0;

reg [7:0] adda_reg1;
reg [7:0] addb_reg1;
reg [7:0] sum_reg1;
reg cout_reg1;

reg [7:0] adda_reg2;
reg [7:0] addb_reg2;
reg [7:0] sum_reg2;
reg cout_reg2;

reg [7:0] adda_reg3;
reg [7:0] addb_reg3;
reg [7:0] sum_reg3;
reg cout_reg3;

reg [7:0] adda_reg4;
reg [7:0] addb_reg4;
reg [7:0] sum_reg4;
reg cout_reg4;

reg [7:0] adda_reg5;
reg [7:0] addb_reg5;
reg [7:0] sum_reg5;
reg cout_reg5;

reg [7:0] adda_reg6;
reg [7:0] addb_reg6;
reg [7:0] sum_reg6;
reg cout_reg6;

reg [7:0] adda_reg7;
reg [7:0] addb_reg7;
reg [7:0] sum_reg7;
reg cout_reg7;

// Capture the input data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg0 <= 8'd0;
        addb_reg0 <= 8'd0;
        adda_reg1 <= 8'd0;
        addb_reg1 <= 8'd0;
        adda_reg2 <= 8'd0;
        addb_reg2 <= 8'd0;
        adda_reg3 <= 8'd0;
        addb_reg3 <= 8'd0;
        adda_reg4 <= 8'd0;
        addb_reg4 <= 8'd0;
        adda_reg5 <= 8'd0;
        addb_reg5 <= 8'd0;
        adda_reg6 <= 8'd0;
        addb_reg6 <= 8'd0;
        adda_reg7 <= 8'd0;
        addb_reg7 <= 8'd0;
    end else if (i_en) begin
        adda_reg0 <= adda[7:0];
        addb_reg0 <= addb[7:0];
        adda_reg1 <= adda[15:8];
        addb_reg1 <= addb[15:8];
        adda_reg2 <= adda[23:16];
        addb_reg2 <= addb[23:16];
        adda_reg3 <= adda[31:24];
        addb_reg3 <= addb[31:24];
        adda_reg4 <= adda[39:32];
        addb_reg4 <= addb[39:32];
        adda_reg5 <= adda[47:40];
        addb_reg5 <= addb[47:40];
        adda_reg6 <= adda[55:48];
        addb_reg6 <= addb[55:48];
        adda_reg7 <= adda[63:56];
        addb_reg7 <= addb[63:56];
    end
end

// Calculate the sums
adder_8bit adder0(
    .a(adda_reg0),
    .b(addb_reg0),
    .sum(sum_reg0),
    .cout(cout_reg0)
);

adder_8bit adder1(
    .a(adda_reg1),
    .b(addb_reg1),
    .sum(sum_reg1),
    .cout(cout_reg1)
);

adder_8bit adder2(
    .a(adda_reg2),
    .b(addb_reg2),
    .sum(sum_reg2),
    .cout(cout_reg2)
);

adder_8bit adder3(
    .a(adda_reg3),
    .b(addb_reg3),
    .sum(sum_reg3),
    .cout(cout_reg3)
);

adder_8bit adder4(
    .a(adda_reg4),
    .b(addb_reg4),
    .sum(sum_reg4),
    .cout(cout_reg4)
);

adder_8bit adder5(
    .a(adda_reg5),
    .b(addb_reg5),
    .sum(sum_reg5),
    .cout(cout_reg5)
);

adder_8bit adder6(
    .a(adda_reg6),
    .b(addb_reg6),
    .sum(sum_reg6),
    .cout(cout_reg6)
);

adder_8bit adder7(
    .a(adda_reg7),
    .b(addb_reg7),
    .sum(sum_reg7),
    .cout(cout_reg7)
);

// Combine the results
reg [63:0] sum_comb;
reg cout_comb;

always @(posedge clk) begin
    sum_comb[7:0] <= sum_reg0;
    sum_comb[15:8] <= sum_reg1;
    sum_comb[23:16] <= sum_reg2;
    sum_comb[31:24] <= sum_reg3;
    sum_comb[39:32] <= sum_reg4;
    sum_comb[47:40] <= sum_reg5;
    sum_comb[55:48] <= sum_reg6;
    sum_comb[63:56] <= sum_reg7;
    cout_comb <= cout_reg7;
end

// Generate the output
always @(posedge clk) begin
    if (i_en) begin
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

assign result[63:0] = sum_comb;
assign result[64] = cout_comb;

endmodule