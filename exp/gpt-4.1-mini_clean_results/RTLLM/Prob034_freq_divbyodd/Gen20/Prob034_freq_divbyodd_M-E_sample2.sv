module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low synchronous reset
    output reg  clk_div
);

    // Compile-time oddness check
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;

    // Counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Pulse signals for toggling clk_div
    wire pulse_a = (cnt == 0);
    wire pulse_b = (cnt == HALF_DIV);

    // Counter logic, synchronous active low reset
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= 0;
        else if (cnt == NUM_DIV - 1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    // clk_div toggling logic on pulses
    always @(posedge clk) begin
        if (!rst_n)
            clk_div <= 0;
        else if (pulse_a || pulse_b)
            clk_div <= ~clk_div;
    end

endmodule