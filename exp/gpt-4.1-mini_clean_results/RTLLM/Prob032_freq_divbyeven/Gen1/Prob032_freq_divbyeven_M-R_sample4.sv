module freq_diveven #
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

    // Counter increment and reset logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 4'd0;
        else if (cnt == HALF_DIV)
            cnt <= 4'd0;
        else
            cnt <= cnt + 4'd1;
    end

    // clk_div toggles when counter resets
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 1'b0;
        else if (cnt == HALF_DIV)
            clk_div <= ~clk_div;
    end

endmodule