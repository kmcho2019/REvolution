module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0]  reg_adda;
reg [63:0]  reg_addb;
reg         reg_i_en;

reg [63:0]  sum [3:0];
reg [3:0]   carry [3:0];

reg [64:0]  reg_result;
reg         reg_o_en;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
        for (i = 0; i < 4; i++) begin
            sum[i] <= 64'd0;
            carry[i] <= 1'b0;
        end
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= i_en;
    end
end

always @(posedge clk) begin
    if (reg_i_en) begin
        sum[0] <= reg_adda + reg_addb;
        carry[0] <= (reg_adda[63] + reg_addb[63]) > 1'b1;
        for (i = 1; i < 4; i++) begin
            sum[i] <= sum[i-1] + {64'd0, carry[i-1]};
            carry[i] <= (sum[i-1][63] + carry[i-1]) > 1'b1;
        end
        reg_result <= {carry[3], sum[3]};
        reg_o_en <= 1'b1;
    end else begin
        reg_o_en <= 1'b0;
    end
end

assign result = reg_result;
assign o_en = reg_o_en;

endmodule