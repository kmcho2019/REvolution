module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Synthesis-time check: NUM_DIV must be even
    generate
        if (NUM_DIV % 2 != 0) begin
            initial $error("Parameter NUM_DIV must be even.");
        end
    endgenerate

    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = (HALF_DIV > 1) ? $clog2(HALF_DIV) : 1;

    // State encoding for clk_div output (0 or 1)
    reg [CNT_WIDTH-1:0] cnt;
    reg state;  // clk_div state 0 or 1

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            state <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= 0;
                state <= ~state;     // Toggle clk_div state
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule