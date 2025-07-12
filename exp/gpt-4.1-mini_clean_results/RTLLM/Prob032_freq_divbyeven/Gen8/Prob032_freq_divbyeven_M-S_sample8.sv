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

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule