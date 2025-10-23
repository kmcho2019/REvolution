module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level states (from low to high)
    typedef enum reg [1:0] {
        BELOW_S0      = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2      = 2'd3
    } water_level_t;

    water_level_t curr_level, prev_level;

    // Function to decode sensor input to water level state
    function water_level_t decode_level(input [2:0] sensors);
        begin
            // According to problem:
            // Above s[2]: s = 3'b111 (all asserted)
            // Between s[2] and s[1]: s = 3'b011 (s0, s1 asserted)
            // Between s[1] and s[0]: s = 3'b001 (only s0 asserted)
            // Below s[0]: s = 3'b000 (none asserted)
            // Treat ambiguous cases by closest state
            casez(sensors)
                3'b111: decode_level = ABOVE_S2;
                3'b011: decode_level = BETWEEN_S2_S1;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b000: decode_level = BELOW_S0;
                3'b010: decode_level = BETWEEN_S2_S1; // s1 only considered BETWEEN_S2_S1
                3'b100: decode_level = ABOVE_S2;      // s2 only considered ABOVE_S2
                3'b101: decode_level = ABOVE_S2;      // s2 and s0 asserted, closer to ABOVE_S2
                3'b110: decode_level = ABOVE_S2;      // s2 and s1 asserted, ABOVE_S2
                default: decode_level = BELOW_S0;
            endcase
        end
    endfunction

    // Sequential logic to track levels and dfr output
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW_S0;
            prev_level <= BELOW_S0;
            dfr <= 1'b1; // On reset, supplemental valve open
        end else begin
            water_level_t new_level;
            new_level = decode_level(s);

            // dfr asserted if water level rose compared to previous
            dfr <= (new_level > curr_level) ? 1'b1 : 1'b0;

            prev_level <= curr_level;
            curr_level <= new_level;
        end
    end

    // Combinational flow valve outputs based on current water level
    always @(*) begin
        // According to table:
        // ABOVE_S2 (all sensors asserted): fr0, fr1, fr2 = 0
        // BETWEEN_S2_S1 (s0, s1 asserted): fr0 = 1; fr1, fr2 = 0
        // BETWEEN_S1_S0 (s0 asserted): fr0=1, fr1=1, fr2=0
        // BELOW_S0 (no sensors asserted): fr0=1, fr1=1, fr2=1
        case (curr_level)
            ABOVE_S2: begin fr0=0; fr1=0; fr2=0; end
            BETWEEN_S2_S1: begin fr0=1; fr1=0; fr2=0; end
            BETWEEN_S1_S0: begin fr0=1; fr1=1; fr2=0; end
            BELOW_S0: begin fr0=1; fr1=1; fr2=1; end
            default: begin fr0=0; fr1=0; fr2=0; end
        endcase
    end

endmodule