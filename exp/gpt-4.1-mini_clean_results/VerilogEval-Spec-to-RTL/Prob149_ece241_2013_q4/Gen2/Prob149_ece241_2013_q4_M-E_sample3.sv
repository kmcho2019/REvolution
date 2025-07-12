module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output reg dfr
);

// Water levels encoding (2 bits)
localparam BELOW_S0       = 2'd0;
localparam BETWEEN_S1_S0  = 2'd1;
localparam BETWEEN_S2_S1  = 2'd2;
localparam ABOVE_S2       = 2'd3;

// Decode sensor pattern to water level.
// For sensor patterns not explicitly listed in the problem, map sensibly:
// - 000: BELOW_S0 (no sensors)
// - 001: BETWEEN_S1_S0 (only s0 asserted)
// - 011: BETWEEN_S2_S1 (s0 and s1 asserted)
// - 111: ABOVE_S2     (all sensors asserted)
// Other patterns assigned to closest level by highest asserted sensor:
//   - 010 (s1 only) -> BETWEEN_S2_S1 (level between s2 and s1)
//   - 100 (s2 only) -> ABOVE_S2
//   - 101 (s2 and s0) -> ABOVE_S2
//   - 110 (s2 and s1) -> ABOVE_S2
function [1:0] decode_level(input [2:0] sensors);
    begin
        case (sensors)
            3'b000: decode_level = BELOW_S0;
            3'b001: decode_level = BETWEEN_S1_S0;
            3'b011: decode_level = BETWEEN_S2_S1;
            3'b111: decode_level = ABOVE_S2;
            3'b010: decode_level = BETWEEN_S2_S1;
            3'b100: decode_level = ABOVE_S2;
            3'b101: decode_level = ABOVE_S2;
            3'b110: decode_level = ABOVE_S2;
            default: decode_level = BELOW_S0;
        endcase
    end
endfunction

// Registers to store current and previous sensor patterns
reg [2:0] prev_sensors;

// Registers to store decoded water levels
reg [1:0] curr_level;
reg [1:0] prev_level_before_change;

always @(posedge clk) begin
    if (reset) begin
        // On reset: no sensors asserted, all flow valves asserted (max flow), dfr asserted
        prev_sensors <= 3'b000;
        curr_level <= BELOW_S0;
        prev_level_before_change <= BELOW_S0;
        dfr <= 1'b1;
    end else begin
        // If sensor pattern changed, update previous level before change and current level
        if (s != prev_sensors) begin
            // prev_level_before_change = decoded level from previous sensor pattern
            prev_level_before_change <= decode_level(prev_sensors);
            // current level = decoded level from current sensor pattern
            curr_level <= decode_level(s);
            // dfr asserted only if water level rose
            dfr <= (decode_level(s) > decode_level(prev_sensors)) ? 1'b1 : 1'b0;
            prev_sensors <= s;
        end else begin
            // No sensor pattern change, dfr deasserted
            dfr <= 1'b0;
            // Keep current level and prev_level_before_change unchanged
        end
    end
end

// Nominal flow valve outputs (combinational) based on current level
assign fr2 = (curr_level == BELOW_S0) ? 1'b1 : 1'b0;
assign fr1 = (curr_level <= BETWEEN_S1_S0) ? 1'b1 : 1'b0;
assign fr0 = (curr_level != ABOVE_S2) ? 1'b1 : 1'b0;

endmodule