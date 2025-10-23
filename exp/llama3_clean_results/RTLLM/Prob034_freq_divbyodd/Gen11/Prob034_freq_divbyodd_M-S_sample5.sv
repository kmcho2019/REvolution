module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter
reg        clk_div_out;  // Clock divider output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_out <= 1'b0;
    end else begin
        cnt <= (cnt == (NUM_DIV - 1))? 0 : cnt + 1;
        if (cnt == ((NUM_DIV - 1) / 2)) begin
            clk_div_out <= ~clk_div_out;
        end
    end
end

assign clk_div = clk_div_out;

endmodule