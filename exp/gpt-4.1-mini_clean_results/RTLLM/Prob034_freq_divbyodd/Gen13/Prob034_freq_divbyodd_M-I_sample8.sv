module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    // To create a clk_div with period = NUM_DIV * clk period,
    // use a counter from 0 to (NUM_DIV * 2) -1
    // clk_div toggles when counter reaches HALF_PERIOD and at zero.
    localparam integer PERIOD = NUM_DIV * 2;
    localparam integer HALF_PERIOD = PERIOD / 2; // equals NUM_DIV

    localparam CNT_WIDTH = $clog2(PERIOD);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == PERIOD - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            if (cnt == 0)
                clk_div <= 1'b1;
            else if (cnt == HALF_PERIOD)
                clk_div <= 1'b0;
            // else maintain clk_div
        end
    end

endmodule