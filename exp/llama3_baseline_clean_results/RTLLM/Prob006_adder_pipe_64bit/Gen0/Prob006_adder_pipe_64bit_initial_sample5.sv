module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg reg_i_en;

reg [63:0] sum;
reg [63:0] carry;

reg [64:0] reg_result;
reg reg_o_en;

// Input registers
always @ (posedge clk or negedge rst_n) begin
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

// 64-bit ripple carry adder
always @ (*) begin
    sum[0] = reg_adda[0] ^ reg_addb[0];
    carry[0] = reg_adda[0] & reg_addb[0];

    for (int i = 1; i < 64; i++) begin
        sum[i] = reg_adda[i] ^ reg_addb[i] ^ carry[i-1];
        carry[i] = (reg_adda[i] & reg_addb[i]) | (reg_adda[i] & carry[i-1]) | (reg_addb[i] & carry[i-1]);
    end
end

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_result <= {carry[63], sum};
        reg_o_en <= 1'b1;
    end else begin
        reg_result <= reg_result;
        reg_o_en <= reg_o_en;
    end
end

assign result = reg_result;
assign o_en = reg_o_en;

endmodule