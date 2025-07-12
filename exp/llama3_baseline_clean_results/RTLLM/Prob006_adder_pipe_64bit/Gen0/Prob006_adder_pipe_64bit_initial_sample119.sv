module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal signals
reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg reg_i_en;
reg [63:0] sum;
reg [63:0] carry;
reg [64:0] pipeline_stage1;
reg [64:0] pipeline_stage2;
reg [64:0] pipeline_stage3;
reg o_en_reg;

// Full adder module
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

// Pipeline stage 1
full_adder fa0(.a(reg_adda[0]),.b(reg_addb[0]),.cin(1'b0),.sum(sum[0]),.cout(carry[0]));
full_adder fa1(.a(reg_adda[1]),.b(reg_addb[1]),.cin(carry[0]),.sum(sum[1]),.cout(carry[1]));
full_adder fa2(.a(reg_adda[2]),.b(reg_addb[2]),.cin(carry[1]),.sum(sum[2]),.cout(carry[2]));
full_adder fa3(.a(reg_adda[3]),.b(reg_addb[3]),.cin(carry[2]),.sum(sum[3]),.cout(carry[3]));
full_adder fa4(.a(reg_adda[4]),.b(reg_addb[4]),.cin(carry[3]),.sum(sum[4]),.cout(carry[4]));
full_adder fa5(.a(reg_adda[5]),.b(reg_addb[5]),.cin(carry[4]),.sum(sum[5]),.cout(carry[5]));
full_adder fa6(.a(reg_adda[6]),.b(reg_addb[6]),.cin(carry[5]),.sum(sum[6]),.cout(carry[6]));
full_adder fa7(.a(reg_adda[7]),.b(reg_addb[7]),.cin(carry[6]),.sum(sum[7]),.cout(carry[7]));
full_adder fa8(.a(reg_adda[8]),.b(reg_addb[8]),.cin(carry[7]),.sum(sum[8]),.cout(carry[8]));
full_adder fa9(.a(reg_adda[9]),.b(reg_addb[9]),.cin(carry[8]),.sum(sum[9]),.cout(carry[9]));
full_adder fa10(.a(reg_adda[10]),.b(reg_addb[10]),.cin(carry[9]),.sum(sum[10]),.cout(carry[10]));
full_adder fa11(.a(reg_adda[11]),.b(reg_addb[11]),.cin(carry[10]),.sum(sum[11]),.cout(carry[11]));
full_adder fa12(.a(reg_adda[12]),.b(reg_addb[12]),.cin(carry[11]),.sum(sum[12]),.cout(carry[12]));
full_adder fa13(.a(reg_adda[13]),.b(reg_addb[13]),.cin(carry[12]),.sum(sum[13]),.cout(carry[13]));
full_adder fa14(.a(reg_adda[14]),.b(reg_addb[14]),.cin(carry[13]),.sum(sum[14]),.cout(carry[14]));
full_adder fa15(.a(reg_adda[15]),.b(reg_addb[15]),.cin(carry[14]),.sum(sum[15]),.cout(carry[15]));

// Generate full adders for bits 16-63
genvar i;
generate
    for (i = 16; i < 64; i = i + 1) begin
        full_adder fa(.a(reg_adda[i]),.b(reg_addb[i]),.cin(carry[i-1]),.sum(sum[i]),.cout(carry[i]));
    end
endgenerate

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipeline_stage1 <= 65'd0;
        pipeline_stage2 <= 65'd0;
        pipeline_stage3 <= 65'd0;
    end else begin
        pipeline_stage1 <= {carry[63], sum};
        pipeline_stage2 <= pipeline_stage1;
        pipeline_stage3 <= pipeline_stage2;
    end
end

// Output register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (reg_i_en) begin
        result <= pipeline_stage3;
        o_en_reg <= 1'b1;
    end else begin
        result <= result;
        o_en_reg <= o_en_reg;
    end
end

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= 1'b1;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        reg_i_en <= reg_i_en;
    end
end

// Output assignment
assign result = result;
assign o_en = o_en_reg;

endmodule