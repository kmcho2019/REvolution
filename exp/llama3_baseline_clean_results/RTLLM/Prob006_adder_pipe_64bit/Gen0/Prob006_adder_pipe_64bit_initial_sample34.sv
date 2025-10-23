module adder_pipe_64bit (
    input            clk,
    input            rst_n,
    input            i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output     [64:0] result,
    output           o_en
);

reg [63:0]          reg_adda;
reg [63:0]          reg_addb;
reg                 reg_i_en;
reg [63:0]          reg_sum;
reg                 reg_carry;
reg                 reg_o_en;

integer              i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda         <= 64'd0;
        reg_addb         <= 64'd0;
        reg_i_en         <= 1'd0;
        reg_sum          <= 64'd0;
        reg_carry        <= 1'd0;
        reg_o_en         <= 1'd0;
    end else if (i_en) begin
        reg_adda         <= adda;
        reg_addb         <= addb;
        reg_i_en         <= 1'd1;
        reg_o_en         <= 1'd0;
    end else if (reg_i_en) begin
        reg_i_en         <= 1'd0;
        reg_o_en         <= 1'd1;
    end
end

always @(posedge clk) begin
    if (reg_i_en) begin
        reg_sum          <= adda + addb;
        reg_carry        <= (adda[63] + addb[63] + 1'd1) > 64'd1;
    end
end

always @(*) begin
    result             = {reg_carry, reg_sum};
    o_en               = reg_o_en;
end

endmodule