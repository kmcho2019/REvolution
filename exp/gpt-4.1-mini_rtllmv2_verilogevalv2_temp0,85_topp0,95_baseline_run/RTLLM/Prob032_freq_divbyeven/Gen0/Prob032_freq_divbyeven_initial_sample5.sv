module freq_diveven #
(
    parameter NUM_DIV = 4  // Must be an even number
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // 4-bit counter
    reg [3:0] cnt;

    // Calculate half division minus one for count limit
    localparam HALF_DIV_MINUS_ONE = (NUM_DIV >> 1) - 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt < HALF_DIV_MINUS_ONE)
                cnt <= cnt + 1;
            else begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;
            end
        end
    end

endmodule