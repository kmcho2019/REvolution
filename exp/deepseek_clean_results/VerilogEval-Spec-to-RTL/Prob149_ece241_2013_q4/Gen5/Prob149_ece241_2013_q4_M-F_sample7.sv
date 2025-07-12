module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Track previous sensor state
    reg [2:0] prev_s;

    // Current state interpretation
    wire above_s2 = &s;          // All sensors on (s[2] & s[1] & s[0])
    wire between_s2_s1 = s[1] & ~s[2];  // s[1] and s[0] on
    wire between_s1_s0 = s[0] & ~s[1];  // Only s[0] on
    wire below_s0 = ~|s;         // No sensors on

    always @(posedge clk) begin
        if (reset) begin
            // Reset to maximum flow state (all outputs high)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Set flow rate outputs based on current level
            fr2 <= below_s0;
            fr1 <= below_s0 | between_s1_s0;
            fr0 <= below_s0 | between_s1_s0 | between_s2_s1;

            // Determine if water level was rising
            // Compare current and previous sensor states
            case ({prev_s, s})
                // Rising cases:
                3'b000_001,  // below_s0 -> between_s1_s0
                3'b000_011,  // below_s0 -> between_s2_s1
                3'b000_111,  // below_s0 -> above_s2
                3'b001_011,  // between_s1_s0 -> between_s2_s1
                3'b001_111,  // between_s1_s0 -> above_s2
                3'b011_111:  // between_s2_s1 -> above_s2
                    dfr <= ~above_s2;  // assert dfr if not at max level
                default:
                    dfr <= 1'b0;
            endcase
        end
    end

endmodule