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
reg reg_i_en;
reg [63:0] reg_sum;
reg [63:0] reg_carry;
reg [64:0] reg_result;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
        reg_result <= 65'd0;
        o_en <= 1'b0;
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
    if (!rst_n) begin
        reg_carry <= 64'd0;
    end else if (reg_i_en) begin
        reg_carry <= 64'd0;
    end else begin
        reg_carry <= reg_carry;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_sum <= 64'd0;
    end else if (reg_i_en) begin
        reg_sum <= reg_adda + reg_addb + reg_carry;
    end else begin
        reg_sum <= reg_sum;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_result <= 65'd0;
    end else if (reg_i_en) begin
        reg_result <= {1'b0, reg_adda} + {1'b0, reg_addb};
    end else begin
        reg_result <= reg_result;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 1'b0;
    end else if (reg_i_en) begin
        o_en <= 1'b1;
    end else begin
        o_en <= o_en;
    end
end

always @(*) begin
    result <= reg_result;
end

endmodule