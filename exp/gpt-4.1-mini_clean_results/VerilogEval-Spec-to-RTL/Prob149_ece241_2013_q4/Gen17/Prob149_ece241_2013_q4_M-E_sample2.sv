module TopModule (
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output reg    dfr
);

    // Define water level states (2-bit)
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // s[0] only
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] & s[1]
    localparam ABOVE_S2      = 2'd3; // s[0], s[1], s[2]

    // Decode sensor pattern into stable water level states
    // Prioritize from highest to lowest level to avoid invalid combos
    // Since sensors at 5-inch intervals, levels ordered as:
    // 3'b111 = above s[2]
    // 3'b011 = between s[2] and s[1]
    // 3'b001 = between s[1] and s[0]
    // 3'b000 = below s[0]
    // For any other pattern, map to closest lower level conservatively
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;
                3'b011: decode_level = BETWEEN_S2_S1;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b000: decode_level = BELOW_S0;
                // fallback for unexpected patterns:
                3'b010: decode_level = BETWEEN_S1_S0;  // s[1] only, treat like between s1,s0
                3'b100: decode_level = BELOW_S0;       // s[2] only, treat like below s0 (fault)
                3'b101: decode_level = BETWEEN_S1_S0;  // s[0] and s[2], treat as between s1,s0
                3'b110: decode_level = BETWEEN_S2_S1;  // s[1] and s[2], treat as between s2,s1
                default: decode_level = BELOW_S0;
            endcase
        end
    endfunction

    // Registers holding previous and current stable water levels
    reg [1:0] level_curr;
    reg [1:0] level_prev;

    // On each clock cycle, latch new stable water level
    // Also detect upward transition: new level > previous level
    // If upward transition, generate a one-cycle pulse on dfr
    reg dfr_pulse;

    always @(posedge clk) begin
        if (reset) begin
            // Reset state: water level low for long time (all valves open)
            level_curr <= BELOW_S0;
            level_prev <= BELOW_S0;
            dfr        <= 1'b1;
            dfr_pulse  <= 1'b0;
        end else begin
            // Latch previous current level before updating current
            level_prev <= level_curr;
            // Decode and update current stable water level
            level_curr <= decode_level(s);

            // Default dfr pulse low
            dfr_pulse <= 1'b0;

            // Check upward transition from previous level to current level
            // dfr pulse asserted only on the cycle immediately after upward transition
            if (decode_level(s) > level_prev)
                dfr_pulse <= 1'b1;

            // Drive dfr output: asserted if dfr pulse or (at reset it was 1)
            dfr <= dfr_pulse;
        end
    end

    // Nominal flow valve outputs combinationally derived from current water level
    // From problem statement:
    // ABOVE_S2: no nominal valves open (fr2=fr1=fr0=0)
    // BETWEEN_S2_S1: fr0 only
    // BETWEEN_S1_S0: fr0 and fr1
    // BELOW_S0: fr0, fr1, fr2
    assign fr0 = (level_curr != ABOVE_S2);  // open except above s2
    assign fr1 = (level_curr == BETWEEN_S1_S0) || (level_curr == BELOW_S0);
    assign fr2 = (level_curr == BELOW_S0);

endmodule