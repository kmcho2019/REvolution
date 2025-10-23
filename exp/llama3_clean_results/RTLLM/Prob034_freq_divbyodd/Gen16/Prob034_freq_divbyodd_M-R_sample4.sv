module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic clk_int;
logic [$clog2(NUM_DIV-1):0] cnt;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_int <= 1'b0;
    end else if (cnt == NUM_DIV - 1) begin
        cnt <= 0;
        clk_int <= ~clk_int;
    end else begin
        cnt <= cnt + 1;
    end
end

assign clk_div = clk_int;

endmodule