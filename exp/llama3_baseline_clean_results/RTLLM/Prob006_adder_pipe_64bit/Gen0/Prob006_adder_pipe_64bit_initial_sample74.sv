module adder_pipe_64bit(
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output     [64:0] result,
    output             o_en
);

reg [63:0]          reg_adda;
reg [63:0]          reg_addb;
reg                 reg_i_en;
reg [64:0]          sum;
reg                 carry;
reg                 o_en_reg;

assign result = sum;
assign o_en    = o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda  <= 64'd0;
        reg_addb  <= 64'd0;
        reg_i_en  <= 1'd0;
        o_en_reg  <= 1'd0;
        sum       <= 65'd0;
    end else if (i_en) begin
        reg_adda  <= adda;
        reg_addb  <= addb;
        reg_i_en  <= 1'd1;
    end else if (reg_i_en) begin
        reg_i_en  <= 1'd0;
    end
end

always @(posedge clk) begin
    if (reg_i_en) begin
        sum       <= reg_adda + reg_addb;
        o_en_reg  <= 1'd1;
    end else begin
        o_en_reg  <= 1'd0;
    end
end

endmodule