module freq_diveven #
(
    parameter NUM_DIV = 6  // Must be even
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;
    localparam HALF = (NUM_DIV >> 1) - 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else if (cnt == HALF) begin
            cnt     <= 4'd0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule