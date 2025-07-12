module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1, adda_reg2;
reg [63:0] addb_reg1, addb_reg2;
reg [64:0] sum_reg1, sum_reg2;
reg i_en_reg1, i_en_reg2, i_en_reg3;

// Input stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= 1'b1;
    end else begin
        adda_reg1 <= adda_reg1;
        addb_reg1 <= addb_reg1;
        i_en_reg1 <= i_en_reg1;
    end
end

// Addition stage
wire [63:0] sum;
wire cout;
always @(*) begin
    sum = adda_reg1 + addb_reg1;
    cout = (adda_reg1[63] & addb_reg1[63]) | (adda_reg1[63] & sum[63]) | (addb_reg1[63] & sum[63]);
end

// First pipeline register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 65'd0;
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
    end else begin
        sum_reg1 <= {cout, sum};
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
    end
end

// Second pipeline register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg2 <= 65'd0;
        i_en_reg3 <= 1'b0;
    end else begin
        sum_reg2 <= sum_reg1;
        i_en_reg3 <= i_en_reg2;
    end
end

// Output stage
assign result = sum_reg2;
assign o_en = i_en_reg3;

endmodule