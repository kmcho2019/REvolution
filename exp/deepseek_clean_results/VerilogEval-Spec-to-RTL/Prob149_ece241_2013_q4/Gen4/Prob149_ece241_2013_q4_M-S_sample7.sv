module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Current state interpretation
    wire above_s2 = s[2];  // All sensors on
    wire between_s2_s1 = s[1] & ~s[2];  // s[1] and s[0] on
    wire between_s1_s0 = s[0] & ~s[1];  // Only s[0] on
    wire below_s0 = ~s[0];  // No sensors on

    // Previous state register
    reg [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Determine if previous level was lower (rising)
    wire was_rising = (s > prev_s);

    // Output logic
    assign fr0 = ~above_s2 & (between_s2_s1 | between_s1_s0 | below_s0);
    assign fr1 = ~above_s2 & (between_s1_s0 | below_s0);
    assign fr2 = below_s0;
    assign dfr = was_rising & ~above_s2;

endmodule