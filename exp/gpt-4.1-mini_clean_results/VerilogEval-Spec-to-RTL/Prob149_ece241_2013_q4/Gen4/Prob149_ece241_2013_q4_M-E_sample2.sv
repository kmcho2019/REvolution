module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define water level states
localparam BELOW_S0      = 2'd0;
localparam BETWEEN_S1_S0 = 2'd1;
localparam BETWEEN_S2_S1 = 2'd2;
localparam ABOVE_S2      = 2'd3;

// Function to decode sensor pattern to water level state
function [1:0] decode_level(input [2:0] sensors);
    begin
        // Sensors: s[2] highest, s[0] lowest
        // According to the spec:
        // s=111 -> ABOVE_S2
        // s=011 -> BETWEEN_S2_S1 (s2=0, s1=1, s0=1)
        // s=001 -> BETWEEN_S1_S0 (only s0 asserted)
        // s=000 -> BELOW_S0
        // Other patterns mapped sensibly:
        case (sensors)
            3'b111: decode_level = ABOVE_S2;
            3'b011: decode_level = BETWEEN_S2_S1;
            3'b001: decode_level = BETWEEN_S1_S0;
            3'b000: decode_level = BELOW_S0;
            // Handle some intermediate sensor states gracefully:
            3'b010: decode_level = BETWEEN_S2_S1; // only s1 asserted
            3'b100: decode_level = ABOVE_S2;      // only s2 asserted
            3'b101: decode_level = ABOVE_S2;      // s2 and s0 asserted
            3'b110: decode_level = ABOVE_S2;      // s2 and s1 asserted
            default: decode_level = BELOW_S0;     // all others -> treat as lowest level for safety
        endcase
    end
endfunction

// Registers to hold current and previous water levels
reg [1:0] curr_level, prev_level;

// On each clock, sample sensors and update states
always @(posedge clk) begin
    if (reset) begin
        // Reset to lowest water level and all valves on
        curr_level <= BELOW_S0;
        prev_level <= BELOW_S0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1; // supplemental valve open on reset (per spec)
    end else begin
        curr_level <= decode_level(s);

        // Detect rising water level (current > prev) for dfr pulse
        if (decode_level(s) > prev_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;

        prev_level <= curr_level;

        // Nominal flow valves based on current water level per spec table
        // Above s[2] (state 3): fr0=0, fr1=0, fr2=0
        // Between s[2]-s[1] (2): fr0=1, fr1=0, fr2=0
        // Between s[1]-s[0] (1): fr0=1, fr1=1, fr2=0
        // Below s[0] (0): fr0=1, fr1=1, fr2=1
        case (decode_level(s))
            ABOVE_S2: begin fr0 <= 1'b0; fr1 <= 1'b0; fr2 <= 1'b0; end
            BETWEEN_S2_S1: begin fr0 <= 1'b1; fr1 <= 1'b0; fr2 <= 1'b0; end
            BETWEEN_S1_S0: begin fr0 <= 1'b1; fr1 <= 1'b1; fr2 <= 1'b0; end
            BELOW_S0: begin fr0 <= 1'b1; fr1 <= 1'b1; fr2 <= 1'b1; end
            default: begin fr0 <= 1'b1; fr1 <= 1'b1; fr2 <= 1'b1; end
        endcase
    end
end

endmodule