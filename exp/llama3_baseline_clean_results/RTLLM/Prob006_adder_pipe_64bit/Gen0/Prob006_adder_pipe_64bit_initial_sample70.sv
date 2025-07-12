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
reg i_en_reg;
reg [63:0] sum;
reg [63:0] carry;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        i_en_reg <= 1'b0;
        sum <= 64'd0;
        carry <= 64'd0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        i_en_reg <= i_en;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        i_en_reg <= i_en_reg;
    end
end

always @(posedge clk) begin
    if (i_en_reg) begin
        carry[0] <= reg_adda[0] + reg_addb[0];
        sum[0] <= reg_adda[0] + reg_addb[0];
        for (int i = 1; i < 64; i++) begin
            carry[i] <= reg_adda[i] + reg_addb[i] + (reg_adda[i-1] + reg_addb[i-1]);
            sum[i] <= reg_adda[i] + reg_addb[i] + (reg_adda[i-1] + reg_addb[i-1]);
        end
        result <= {1'b0, sum};
        o_en <= 1'b1;
    end else begin
        carry <= 64'd0;
        sum <= 64'd0;
        result <= 65'd0;
        o_en <= 1'b0;
    end
end

endmodule