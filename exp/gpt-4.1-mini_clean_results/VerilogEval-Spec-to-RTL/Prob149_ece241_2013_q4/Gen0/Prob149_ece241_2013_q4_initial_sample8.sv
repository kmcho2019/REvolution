module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Define water level states
localparam [1:0]
    BELOW_S0          = 2'd0,
    BETWEEN_S1_S0     = 2'd1,
    BETWEEN_S2_S1     = 2'd2,
    ABOVE_S2          = 2'd3;

reg [1:0] curr_level, prev_level;

// Function to decode water level from sensor input s
// Sensors are vertical: s[2] highest, s[1] middle, s[0] lowest
// Water level states defined as per problem:
// Above s[2] means all sensors asserted (111)
// Between s[2] and s[1]: s[2]=0, s[1]=1, s[0]=1 (110)
// Between s[1] and s[0]: s[2]=0, s[1]=0, s[0]=1 (100)
// Below s[0]: none asserted (000)
//
// The problem states these are expected states; any other combination can
// be normalized to the closest matching category.
//
// We prioritize from highest to lowest level:

function [1:0] decode_level(input [2:0] s_in);
    begin
        casez (s_in)
            3'b111: decode_level = ABOVE_S2;
            3'b11?: decode_level = BETWEEN_S2_S1; // 110 or 111 but 111 handled above
            3'b1?0: decode_level = BETWEEN_S1_S0; // 100 or 110 but 110 handled above
            3'b0??: decode_level = BELOW_S0;      // 0xx including 000
            default: decode_level = BELOW_S0;    // default fallback
        endcase
    end
endfunction

// On every clock, update the water level state and outputs
// Detect if water level increased compared to previous level:
// level increases if curr_level > prev_level

wire level_increased;

assign level_increased = (curr_level > prev_level);

always @(posedge clk) begin
    if (reset) begin
        // Reset state: assume level low for long time
        // no sensors asserted (below s[0]) and all outputs asserted
        curr_level <= BELOW_S0;
        prev_level <= BELOW_S0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous level to last current before update
        prev_level <= curr_level;
        curr_level <= decode_level(s);

        // Drive outputs based on current water level and level increase
        case (decode_level(s))
            ABOVE_S2: begin
                // Above s[2]: flow rate zero = all fr outputs low, dfr low
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BETWEEN_S2_S1: begin
                // fr0 only asserted
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BETWEEN_S1_S0: begin
                // fr0, fr1 asserted
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BELOW_S0: begin
                // fr0, fr1, fr2 asserted
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            default: begin
                // Defensive default: treat as below s0
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
        endcase
    end
end

endmodule