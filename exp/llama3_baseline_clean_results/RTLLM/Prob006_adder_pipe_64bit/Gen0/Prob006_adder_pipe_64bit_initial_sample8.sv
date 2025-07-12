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
reg [63:0] reg_result;
reg [63:0] reg_carry;
reg [1:0] reg_i_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 64'd0;
        reg_carry <= 64'd0;
        reg_i_en <= 2'd0;
        o_en <= 1'd0;
    end else begin
        reg_i_en[0] <= i_en;
        reg_i_en[1] <= reg_i_en[0];
        
        if (reg_i_en[0]) begin
            reg_adda <= adda;
            reg_addb <= addb;
        end
        
        if (reg_i_en[1]) begin
            {reg_carry, reg_result} <= reg_adda + reg_addb;
        end
        
        o_en <= reg_i_en[1];
    end
end

always @(posedge clk) begin
    result <= {reg_carry, reg_result};
end

endmodule