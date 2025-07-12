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
reg [63:0] reg_sum;
reg [63:0] reg_carry;
reg [64:0] reg_result;
reg reg_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'd0;
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
        reg_result <= 65'd0;
        reg_o_en <= 1'd0;
    end else begin
        // Input stage
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= i_en;

        // Addition stage
        if (reg_i_en) begin
            reg_sum <= reg_adda + reg_addb;
            reg_carry <= (reg_adda[63] + reg_addb[63]) > 1'd1 ? 1'd1 : 1'd0;
        end else begin
            reg_sum <= 64'd0;
            reg_carry <= 64'd0;
        end

        // Output stage
        if (reg_i_en) begin
            reg_result <= {reg_carry, reg_sum};
            reg_o_en <= 1'd1;
        end else begin
            reg_result <= 65'd0;
            reg_o_en <= 1'd0;
        end
    end
end

assign result = reg_result;
assign o_en = reg_o_en;

endmodule