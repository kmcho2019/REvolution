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
reg [64:0] reg_result;
reg reg_o_en;

assign result = reg_result;
assign o_en = reg_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
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

reg [63:0] sum [7:0];
reg [0:7] carry [7:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 64'd0;
            carry[i] <= 1'b0;
        end
    end else if (reg_i_en) begin
        sum[0] <= reg_adda[7:0] + reg_addb[7:0];
        carry[0] <= (reg_adda[7:0] + reg_addb[7:0]) [8];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= {carry[i-1], reg_adda[(i*8)+7:(i*8)]} + {carry[i-1], reg_addb[(i*8)+7:(i*8)]};
            carry[i] <= ({carry[i-1], reg_adda[(i*8)+7:(i*8)]} + {carry[i-1], reg_addb[(i*8)+7:(i*8)]}) [8];
        end
    end else begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= sum[i];
            carry[i] <= carry[i];
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_result <= {carry[7], {sum[7], sum[6], sum[5], sum[4], sum[3], sum[2], sum[1], sum[0]}};
        reg_o_en <= 1'b1;
    end else begin
        reg_result <= reg_result;
        reg_o_en <= reg_o_en;
    end
end

endmodule