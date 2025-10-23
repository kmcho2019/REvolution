module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    localparam integer HALF_DIV = NUM_DIV >> 1;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Counter increments until HALF_DIV-1, then resets
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    // Toggle clk_div when counter hits HALF_DIV - 1
    wire toggle_enable = (cnt == HALF_DIV - 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 0;
        end else if (toggle_enable) begin
            clk_div <= ~clk_div;
        end
    end

endmodule