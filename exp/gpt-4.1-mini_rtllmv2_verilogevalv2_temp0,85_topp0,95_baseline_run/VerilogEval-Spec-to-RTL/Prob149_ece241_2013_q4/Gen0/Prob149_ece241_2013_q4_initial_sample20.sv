module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// We interpret s as three sensors from bottom (s[0]) to top (s[2])
// Water level classification:
// - Above s[2]: s == 3'b111 (all sensors asserted)
// - Between s[2] and s[1]: s == 3'b011 (s0 and s1 asserted)
// - Between s[1] and s[0]: s == 3'b001 (only s0 asserted)
// - Below s[0]: s == 3'b000 (no sensors asserted)

reg [2:0] prev_s;

// Function to determine numeric water level from sensor bits for comparison
// We assign levels by interpreting sensor patterns:
// Higher level means more sensors asserted from the bottom upwards
// Level encoding:
// 0 -> no sensors asserted (below s0)
// 1 -> s == 3'b001
// 2 -> s == 3'b011
// 3 -> s == 3'b111 (above s2)
function [1:0] water_level;
    input [2:0] sensors;
    begin
        case (sensors)
            3'b000: water_level = 2'd0; // below s0
            3'b001: water_level = 2'd1; // between s0 and s1
            3'b011: water_level = 2'd2; // between s1 and s2
            3'b111: water_level = 2'd3; // above s2
            default: water_level = 2'd0; // Treat other cases as below s0 (safe default)
        endcase
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset to state: no sensors asserted, all outputs asserted
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b0;
    end else begin
        // Update prev_s only on sensor change
        if (s != prev_s) begin
            prev_s <= s;
        end

        // Nominal flow valves based on current sensor input s
        case (s)
            3'b111: begin
                // Above s2: all flow valves off
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            3'b011: begin
                // Between s2 and s1: fr0 on only
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            3'b001: begin
                // Between s1 and s0: fr0 and fr1 on
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b000: begin
                // Below s0: all flow valves on
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin
                // For other cases, default to below s0 condition
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase

        // Supplemental flow valve dfr on if current water level > previous water level
        if (water_level(s) > water_level(prev_s)) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule