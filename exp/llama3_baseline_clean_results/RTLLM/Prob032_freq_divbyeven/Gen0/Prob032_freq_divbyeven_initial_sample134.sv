module freq_diveven #(
    parameter NUM_DIV = 4  // Must be an even number
)(
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [3:0] cnt;
logic       clk_div_reg;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt          <= 4'd0;
        clk_div_reg  <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt      <= cnt + 1;
            clk_div_reg  <= clk_div_reg;
        end else begin
            cnt      <= 4'd0;
            clk_div_reg  <= ~clk_div_reg;
        end
    end
end

assign clk_div = clk_div_reg;

endmodule