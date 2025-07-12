module freq_divbyeven #
(
    parameter NUM_DIV = 4  // Must be even
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // 4-bit counter
    reg [3:0] cnt;

    // Half period count value
    localparam HALF_DIV = (NUM_DIV >> 1) - 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt < HALF_DIV)
                cnt <= cnt + 4'd1;
            else begin
                cnt <= 4'd0;
                clk_div <= ~clk_div;
            end
        end
    end

endmodule