module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Previous sensor values for edge detection
    reg [2:0] prev_s;
    reg was_rising;

    // Edge detection and transition tracking
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            was_rising <= 1'b0;
        end else begin
            prev_s <= s;
            // Set was_rising if any sensor just became active
            was_rising <= |(s & ~prev_s);
        end
    end

    // Current rising edge detection (combinational)
    wire rising_now = |(s & ~prev_s);

    // Nominal flow outputs (combinational)
    assign fr0 = (s != 3'b111);  // On unless all sensors active
    assign fr1 = (s == 3'b000) || (s == 3'b001); // On when below s1
    assign fr2 = (s == 3'b000);  // On only when below s0

    // Supplemental flow output (combinational)
    // Active when either:
    // 1. We're currently seeing a rising edge, or
    // 2. We saw a rising edge last cycle and are still not at max level
    // And we're not in the "all sensors active" state
    assign dfr = ((rising_now || was_rising) && (s != 3'b111)) || reset;

endmodule