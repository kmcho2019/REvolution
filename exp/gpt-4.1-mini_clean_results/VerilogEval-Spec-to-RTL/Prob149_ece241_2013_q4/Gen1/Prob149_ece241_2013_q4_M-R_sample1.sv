module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output reg dfr
);

// Water levels encoding (2-bit)
localparam BELOW_S0   = 2'd0;
localparam BETWEEN_S1_S0 = 2'd1;
localparam BETWEEN_S2_S1 = 2'd2;
localparam ABOVE_S2   = 2'd3;

// Decode sensors to level
// For ambiguous sensor patterns not in {000,001,011,111}, map to closest known state:
// 010 -> BETWEEN_S1_S0 (s[1] only)
// 100 -> BETWEEN_S2_S1 (s[2] only)
// 101 -> ABOVE_S2       (s[2] and s[0])
// 110 -> ABOVE_S2       (s[2] and s[1])
function [1:0] decode_level;
    input [2:0] sensors;
    begin
        case (sensors)
            3'b000: decode_level = BELOW_S0;
            3'b001: decode_level = BETWEEN_S1_S0;
            3'b011: decode_level = BETWEEN_S2_S1;
            3'b111: decode_level = ABOVE_S2;
            3'b010: decode_level = BETWEEN_S1_S0;
            3'b100: decode_level = BETWEEN_S2_S1;
            3'b101: decode_level = ABOVE_S2;
            3'b110: decode_level = ABOVE_S2;
            default: decode_level = BELOW_S0; // default safest
        endcase
    end
endfunction

// Registers for current level and previous stable level before last change
reg [1:0] curr_level;
reg [1:0] prev_level_before_change;

// To detect sensor input change triggering level change
reg [1:0] prev_level_sample;

// Update levels and dfr logic on clock
always @(posedge clk) begin
    if (reset) begin
        curr_level <= BELOW_S0;  // Reset to lowest level
        prev_level_before_change <= BELOW_S0;
        prev_level_sample <= BELOW_S0;
        dfr <= 1'b1; // From problem: all flow valves asserted initially, dfr asserted indicating low level for a long time
    end else begin
        // Decode current sensors into level
        curr_level <= decode_level(s);

        // If level changed since last sample, update prev_level_before_change and dfr
        if (curr_level != prev_level_sample) begin
            // dfr asserted if water level is rising (curr > prev_level_before_change)
            dfr <= (curr_level > prev_level_before_change) ? 1'b1 : 1'b0;

            // Update previous stable level before last change to previous sample level
            prev_level_before_change <= prev_level_sample;
        end else begin
            // No level change, hold dfr
            dfr <= 1'b0;
        end

        prev_level_sample <= curr_level;
    end
end

// Nominal flow valve outputs (combinational)
assign fr2 = (curr_level == BELOW_S0) ? 1'b1 : 1'b0;
assign fr1 = (curr_level <= BETWEEN_S1_S0) ? 1'b1 : 1'b0;
assign fr0 = (curr_level != ABOVE_S2) ? 1'b1 : 1'b0;

endmodule