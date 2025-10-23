module adder_pipe_64bit (
    input            clk,
    input            rst_n,
    input            i_en,
    input    [63:0]  adda,
    input    [63:0]  addb,
    output   [64:0]  result,
    output           o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_sum;
reg         reg_cout;
reg         reg_o_en;

assign result = {reg_cout, reg_sum};
assign o_en = reg_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        reg_cout <= 1'd0;
        reg_o_en <= 1'd0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_o_en <= 1'd0;
    end else if (reg_adda != 0 || reg_addb != 0) begin
        {reg_cout, reg_sum} <= reg_adda + reg_addb + reg_cout;
        reg_o_en <= 1'd1;
    end else begin
        reg_o_en <= 1'd0;
    end
end

endmodule