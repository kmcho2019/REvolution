module freq_diveven #
(
    parameter NUM_DIV = 4  // Even number division factor
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    localparam HALF_DIV = NUM_DIV >> 1;
    reg [$clog2(HALF_DIV)-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt     <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule