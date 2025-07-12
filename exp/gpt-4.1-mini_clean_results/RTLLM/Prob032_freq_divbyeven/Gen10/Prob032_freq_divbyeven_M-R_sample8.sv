module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Runtime parameter check
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV must be even and >= 2 (got %0d)", NUM_DIV);
            $finish;
        end
    end

    localparam HALF_DIV = NUM_DIV >> 1;
    localparam CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt, cnt_next;
    reg clk_div_r, clk_div_next;

    // Combinational next-state logic
    always @(*) begin
        if (cnt == HALF_DIV - 1) begin
            cnt_next = 0;
            clk_div_next = ~clk_div_r;
        end else begin
            cnt_next = cnt + 1;
            clk_div_next = clk_div_r;
        end
    end

    // Sequential state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div_r <= 0;
        end else begin
            cnt      <= cnt_next;
            clk_div_r <= clk_div_next;
        end
    end

    assign clk_div = clk_div_r;

endmodule