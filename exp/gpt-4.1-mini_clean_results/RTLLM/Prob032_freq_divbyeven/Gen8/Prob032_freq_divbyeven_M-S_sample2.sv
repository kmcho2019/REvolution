module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;  // 4-bit counter as specified
    localparam HALF_DIV = NUM_DIV >> 1;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule