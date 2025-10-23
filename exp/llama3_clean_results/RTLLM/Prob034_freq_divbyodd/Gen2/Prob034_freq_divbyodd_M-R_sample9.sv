module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;
reg        clk_div_int;

assign clk_div = clk_div_int;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else if (cnt == (NUM_DIV - 1) / 2) begin
        cnt <= cnt + 1;
        clk_div_int <= ~clk_div_int;
    end else if (cnt == NUM_DIV - 1) begin
        cnt <= 0;
        clk_div_int <= 1'b0;  // Reset clk_div_int to 0 after a full cycle
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule