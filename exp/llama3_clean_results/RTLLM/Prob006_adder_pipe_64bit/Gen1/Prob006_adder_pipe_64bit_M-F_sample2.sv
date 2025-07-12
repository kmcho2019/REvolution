module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_sum;
reg        reg_carry;
reg        reg_o_en;
reg        reg_i_en_pipe;

assign result = {reg_carry, reg_sum};
assign o_en = reg_o_en;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        reg_carry <= 1'b0;
        reg_o_en <= 1'b0;
        reg_i_en_pipe <= 1'b0;
    end else begin
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
            reg_i_en_pipe <= 1'b1;
        end else begin
            reg_i_en_pipe <= 1'b0;
        end
    end
end

always @ (posedge clk) begin
    reg [63:0] temp_sum;
    reg        temp_carry;
    temp_sum = reg_adda + reg_addb;
    temp_carry = (reg_adda[63] + reg_addb[63]) > 63 ? 1'b1 : 1'b0;
    if (reg_i_en_pipe) begin
        reg_sum <= temp_sum;
        reg_carry <= temp_carry;
        reg_o_en <= 1'b1;
    end else begin
        reg_o_en <= 1'b0;
    end
end

endmodule