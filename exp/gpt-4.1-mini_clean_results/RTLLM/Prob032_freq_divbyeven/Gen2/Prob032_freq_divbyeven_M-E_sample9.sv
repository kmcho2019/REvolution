module freq_diveven #
(
    parameter NUM_DIV = 8  // Must be even
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);
    reg [CNT_WIDTH-1:0] cnt;

    // Half point for toggling clock (NUM_DIV/2 - 1)
    localparam TOGGLE_POINT = (NUM_DIV >> 1) - 1;
    // Maximum count value (NUM_DIV - 1)
    localparam MAX_COUNT = NUM_DIV - 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == MAX_COUNT) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1'b1;
            end

            // Toggle clk_div when counter reaches TOGGLE_POINT
            if (cnt == TOGGLE_POINT) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule