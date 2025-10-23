module adder_pipe_64bit(
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
reg [63:0] reg_sum;
reg carry;
reg [63:0] reg_carry;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        carry <= 1'b0;
        reg_carry <= 64'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_sum <= 64'd0;
        carry <= 1'b0;
    end else begin
        reg_sum <= reg_adda + reg_addb + carry;
        carry <= (reg_adda[0] & reg_addb[0]) | (reg_adda[0] & carry) | (reg_addb[0] & carry);
        for (int i = 1; i < 64; i++) begin
            reg_carry[i] <= (reg_adda[i] & reg_addb[i]) | (reg_adda[i] & reg_carry[i-1]) | (reg_addb[i] & reg_carry[i-1]);
            reg_sum[i] <= reg_adda[i] + reg_addb[i] + reg_carry[i-1];
        end
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        o_en_reg <= 1'b0;
    end else if (reg_adda != 64'd0 || reg_addb != 64'd0) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

always @ (posedge clk) begin
    result <= {1'b0, reg_sum} + {64'd0, carry};
    o_en <= o_en_reg;
end

endmodule