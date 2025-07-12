module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input  [63:0]       adda,
    input  [63:0]       addb,
    output [64:0]       result,
    output              o_en
);

reg [63:0]       reg_adda;
reg [63:0]       reg_addb;
reg             reg_i_en;
reg [64:0]       reg_sum1;
reg [64:0]       reg_sum2;
reg [64:0]       reg_sum3;
reg             reg_o_en1;
reg             reg_o_en2;
reg             reg_o_en3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda       <= 64'd0;
        reg_addb       <= 64'd0;
        reg_i_en       <= 1'b0;
        reg_sum1       <= 65'd0;
        reg_sum2       <= 65'd0;
        reg_sum3       <= 65'd0;
        reg_o_en1      <= 1'b0;
        reg_o_en2      <= 1'b0;
        reg_o_en3      <= 1'b0;
    end else begin
        reg_adda       <= adda;
        reg_addb       <= addb;
        reg_i_en       <= i_en;
        reg_sum1       <= reg_adda + reg_addb;
        reg_sum2       <= reg_sum1;
        reg_sum3       <= reg_sum2;
        reg_o_en1      <= reg_i_en;
        reg_o_en2      <= reg_o_en1;
        reg_o_en3      <= reg_o_en2;
    end
end

assign result = reg_sum3;
assign o_en   = reg_o_en3;

endmodule