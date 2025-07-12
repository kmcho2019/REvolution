module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Water level encoding
localparam [1:0]
    BELOW_S0      = 2'd0,
    BETWEEN_S1_S0 = 2'd1,
    BETWEEN_S2_S1 = 2'd2,
    ABOVE_S2      = 2'd3;

// Function to decode the exact water level from sensor inputs
function [1:0] decode_level(input [2:0] s_in);
begin
    case (s_in)
        3'b111: decode_level = ABOVE_S2;       // Above s[2]
        3'b011: decode_level = BETWEEN_S2_S1;  // Between s[2] and s[1]
        3'b001: decode_level = BETWEEN_S1_S0;  // Between s[1] and s[0]
        3'b000: decode_level = BELOW_S0;       // Below s[0]
        default: decode_level = BELOW_S0;       // Treat all other cases as BELOW_S0 for safety
    endcase
end
endfunction

// Registers to hold previous and current level states
reg [1:0] prev_level;
reg [1:0] curr_level;
reg       level_increased;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset: initialize to BELOW_S0 and all flows asserted
        prev_level     <= BELOW_S0;
        curr_level     <= BELOW_S0;
        level_increased <= 1'b0;

        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Decode new level from current sensor input
        curr_level <= decode_level(s);

        // Store previous level for comparison next cycle
        prev_level <= curr_level;

        // Compare current level (just updated) to previous level (old value before this clock)
        // Because non-blocking assignments update simultaneously, prev_level holds old curr_level.
        level_increased <= (decode_level(s) > curr_level) ? 1'b0 : 1'b0; // Wrong, will fix below

        // The line above is incorrect because curr_level and decode_level(s) are same on RHS. Instead, use old prev_level to compare with new curr_level.
        // However, non-blocking assignments update at end of clock cycle, so here prev_level is old, curr_level is new after update, but in RHS both refer to old values.
        // To fix, rearrange assignments: save previous level in a temp variable before updating curr_level.

        // Implement as follows:
    end
end

// The above logic has a sequencing problem because prev_level is assigned at the same clock as curr_level, so at RHS they hold old values.
// To solve this, use a temporary reg for previous level to store before updating curr_level.

reg [1:0] prev_level_d;

// Revised always block combining all in one:

always @(posedge clk) begin
    if (reset) begin
        prev_level     <= BELOW_S0;
        curr_level     <= BELOW_S0;
        level_increased <= 1'b0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
        prev_level_d <= BELOW_S0;
    end else begin
        prev_level_d <= curr_level;          // Save old curr_level before updating

        curr_level <= decode_level(s);

        // After curr_level updated, compare with previous level stored in prev_level_d
        level_increased <= (decode_level(s) > prev_level_d);

        prev_level <= prev_level_d;

        // Drive outputs based on curr_level and level_increased
        case (decode_level(s))
            ABOVE_S2: begin
                // Flow rate zero: all flow valves off
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BETWEEN_S2_S1: begin
                // Nominal flow: fr0
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BETWEEN_S1_S0: begin
                // Nominal flow: fr0, fr1
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BELOW_S0: begin
                // Maximum flow: fr0, fr1, fr2
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            default: begin
                // Default safe case: maximum flow (same as BELOW_S0)
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
        endcase
    end
end

endmodule