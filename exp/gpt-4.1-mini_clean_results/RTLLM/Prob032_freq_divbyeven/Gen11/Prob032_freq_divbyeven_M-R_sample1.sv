module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
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

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule