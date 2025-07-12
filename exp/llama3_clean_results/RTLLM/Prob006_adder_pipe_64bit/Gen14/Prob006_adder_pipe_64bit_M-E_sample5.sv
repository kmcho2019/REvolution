// Define a full adder module
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a 16-bit ripple carry adder module
module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input  cin,
    output [15:0] sum,
    output cout
);
    wire [3:0] carry;
    assign carry[0] = cin;
    full_adder fa0 (.a(a[0]),.b(b[0]),.cin(carry[0]),.sum(sum[0]),.cout(carry[1]));
    full_adder fa1 (.a(a[1]),.b(b[1]),.cin(carry[1]),.sum(sum[1]),.cout(carry[2]));
    full_adder fa2 (.a(a[2]),.b(b[2]),.cin(carry[2]),.sum(sum[2]),.cout(carry[3]));
    full_adder fa3 (.a(a[3]),.b(b[3]),.cin(carry[3]),.sum(sum[3]),.cout(carry[4]));
    full_adder fa4 (.a(a[4]),.b(b[4]),.cin(carry[4]),.sum(sum[4]),.cout(carry[5]));
    full_adder fa5 (.a(a[5]),.b(b[5]),.cin(carry[5]),.sum(sum[5]),.cout(carry[6]));
    full_adder fa6 (.a(a[6]),.b(b[6]),.cin(carry[6]),.sum(sum[6]),.cout(carry[7]));
    full_adder fa7 (.a(a[7]),.b(b[7]),.cin(carry[7]),.sum(sum[7]),.cout(carry[8]));
    full_adder fa8 (.a(a[8]),.b(b[8]),.cin(carry[8]),.sum(sum[8]),.cout(carry[9]));
    full_adder fa9 (.a(a[9]),.b(b[9]),.cin(carry[9]),.sum(sum[9]),.cout(carry[10]));
    full_adder fa10 (.a(a[10]),.b(b[10]),.cin(carry[10]),.sum(sum[10]),.cout(carry[11]));
    full_adder fa11 (.a(a[11]),.b(b[11]),.cin(carry[11]),.sum(sum[11]),.cout(carry[12]));
    full_adder fa12 (.a(a[12]),.b(b[12]),.cin(carry[12]),.sum(sum[12]),.cout(carry[13]));
    full_adder fa13 (.a(a[13]),.b(b[13]),.cin(carry[13]),.sum(sum[13]),.cout(carry[14]));
    full_adder fa14 (.a(a[14]),.b(b[14]),.cin(carry[14]),.sum(sum[14]),.cout(carry[15]));
    full_adder fa15 (.a(a[15]),.b(b[15]),.cin(carry[15]),.sum(sum[15]),.cout(cout));
endmodule

// Define the 64-bit ripple carry adder module with pipeline stages
module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg [63:0] adda_reg2;
reg [63:0] addb_reg2;
reg [63:0] adda_reg3;
reg [63:0] addb_reg3;
reg [63:0] adda_reg4;
reg [63:0] addb_reg4;
reg        i_en_reg1;
reg        i_en_reg2;
reg        i_en_reg3;

// Input stage
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= 1'b1;
    end
end

// Addition stage
reg [15:0] sum1;
reg [15:0] sum2;
reg [15:0] sum3;
reg [15:0] sum4;
reg cout1;
reg cout2;
reg cout3;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
    end else if (i_en_reg1) begin
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= 1'b1;
    end
end
adder_16bit adder1 (.a(adda_reg2[15:0]),.b(addb_reg2[15:0]),.cin(1'b0),.sum(sum1),.cout(cout1));
adder_16bit adder2 (.a(adda_reg2[31:16]),.b(addb_reg2[31:16]),.cin(cout1),.sum(sum2),.cout(cout2));
adder_16bit adder3 (.a(adda_reg2[47:32]),.b(addb_reg2[47:32]),.cin(cout2),.sum(sum3),.cout(cout3));
adder_16bit adder4 (.a(adda_reg2[63:48]),.b(addb_reg2[63:48]),.cin(cout3),.sum(sum4),.cout(result[64]));

// Carry propagation stage
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg3 <= 64'd0;
        addb_reg3 <= 64'd0;
        i_en_reg3 <= 1'b0;
    end else if (i_en_reg2) begin
        adda_reg3 <= {sum4, sum3, sum2, sum1};
        addb_reg3 <= 64'd0;
        i_en_reg3 <= 1'b1;
    end
end

// Output stage
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg4 <= 64'd0;
        addb_reg4 <= 64'd0;
        o_en <= 1'b0;
    end else if (i_en_reg3) begin
        adda_reg4 <= adda_reg3;
        addb_reg4 <= addb_reg3;
        o_en <= 1'b1;
    end
end
assign result[63:0] = adda_reg4;

endmodule