module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Level ordinal encoding:
    // 0 = BELOW_S0 (no sensors asserted)
    // 1 = BETWEEN_S1_S0 (only s[0])
    // 2 = BETWEEN_S2_S1 (s[0] and s[1])
    // 3 = ABOVE_S2 (all three sensors)
    reg [1:0] curr_level, prev_level, prev_prev_level;

    wire [1:0] decoded_level;

    // Combinational decoding of sensors into water level ordinal
    // According to problem:
    // Above s[2] = all three asserted => 3
    // Between s[2] and s[1] = s[0], s[1] asserted only => 2
    // Between s[1] and s[0] = s[0] asserted only => 1
    // Below s[0] = none asserted => 0
    // Any other combination also interpreted into closest lower state
    assign decoded_level = (s[2] & s[1] & s[0]) ? 2'd3 :
                           (s[1] & s[0] & ~s[2]) ? 2'd2 :
                           (s[0] & ~s[1] & ~s[2]) ? 2'd1 :
                           2'd0;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to lowest level (below s0) so all valves open
            curr_level      <= 2'd0;
            prev_level      <= 2'd0;
            prev_prev_level <= 2'd0;
        end else begin
            // Shift levels: current -> prev, prev -> prev_prev, new current from sensors
            prev_prev_level <= prev_level;
            prev_level      <= curr_level;
            curr_level      <= decoded_level;
        end
    end

    // dfr asserted if current level > prev_prev_level (level rose compared to two samples ago)
    assign dfr = (curr_level > prev_prev_level);

    // Nominal flow valves per problem specification:
    // level = 0 (below s0): fr0, fr1, fr2
    // level = 1 (between s1 and s0): fr0, fr1
    // level = 2 (between s2 and s1): fr0
    // level = 3 (above s2): none nominal valves open
    assign fr0 = (curr_level != 2'd3);
    assign fr1 = (curr_level == 2'd1) || (curr_level == 2'd0);
    assign fr2 = (curr_level == 2'd0);

endmodule