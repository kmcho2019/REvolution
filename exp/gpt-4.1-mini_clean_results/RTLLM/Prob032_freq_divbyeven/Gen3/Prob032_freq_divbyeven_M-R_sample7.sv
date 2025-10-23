module freq_diveven #
(
    parameter NUM_DIV = 4  // Must be even
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check that NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be even, got %0d", NUM_DIV);
            $finish;
        end
    end

    // Half division factor
    localparam HALF_DIV = NUM_DIV >> 1;
    localparam CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;
    reg [CNT_WIDTH-1:0] cnt_next;
    reg                 clk_div_next;

    // Combinational next-state logic
    always @(*) begin
        if (cnt == HALF_DIV - 1) begin
            cnt_next     = {CNT_WIDTH{1'b0}};
            clk_div_next = ~clk_div;
        end else begin
            cnt_next     = cnt + 1'b1;
            clk_div_next = clk_div;
        end
    end

    // Sequential update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            cnt     <= cnt_next;
            clk_div <= clk_div_next;
        end
    end

endmodule