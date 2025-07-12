module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_result;
reg [63:0] reg_carry;
reg reg_i_en;
reg reg_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 64'd0;
        reg_carry <= 64'd0;
        reg_i_en <= 1'b0;
        reg_o_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= i_en;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        reg_i_en <= reg_i_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_result <= 64'd0;
        reg_carry <= 64'd0;
        reg_o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_carry <= 1'b0;
        for (int i = 0; i < 64; i++) begin
            reg_result[i] <= reg_adda[i] ^ reg_addb[i] ^ reg_carry;
            reg_carry[i+1] <= (reg_adda[i] & reg_addb[i]) | (reg_adda[i] & reg_carry) | (reg_addb[i] & reg_carry);
        end
        reg_o_en <= 1'b1;
    end else begin
        reg_result <= reg_result;
        reg_carry <= reg_carry;
        reg_o_en <= reg_o_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        result <= {reg_carry[63], reg_result};
        o_en <= reg_o_en;
    end
end

endmodule