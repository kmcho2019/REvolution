module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV-1):0] cnt;
logic clk_div_int;

assign cnt = (rst_n) ? (cnt + 1) : 0;
assign clk_div_int = (cnt == (NUM_DIV - 1)) ? ~clk_div_int : clk_div_int;

assign clk_div = clk_div_int;

always @(posedge clk) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else if (cnt == (NUM_DIV - 1)) begin
        cnt <= 0;
    end
end

endmodule