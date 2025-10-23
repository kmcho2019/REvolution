module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level states
    typedef enum logic [1:0] {
        LEVEL0 = 2'd0, // Below s[0] (no sensors asserted)
        LEVEL1 = 2'd1, // Between s[1] and s[0] (only s[0] asserted)
        LEVEL2 = 2'd2, // Between s[2] and s[1] (s[0], s[1] asserted)
        LEVEL3 = 2'd3  // Above s[2] (all sensors asserted)
    } level_t;

    level_t curr_level;
    level_t curr_state;  // current water level state
    level_t prev_state;  // previous water level state (last cycle)
    level_t last_level_before_change; // water level before the last sensor change

    // Function to decode sensor inputs into water level state
    // Sensors are vertically stacked: s[0] lowest, s[2] highest
    // Valid sensor patterns have contiguous 1s from bottom up:
    // 000 -> LEVEL0
    // 001 -> LEVEL1
    // 011 -> LEVEL2
    // 111 -> LEVEL3
    // For invalid patterns, decode as highest contiguous prefix from bottom
    function automatic level_t decode_level(input [2:0] sensors);
        begin
            casez(sensors)
                3'b000: decode_level = LEVEL0;
                3'b001: decode_level = LEVEL1;
                3'b011: decode_level = LEVEL2;
                3'b111: decode_level = LEVEL3;
                default: begin
                    // Invalid pattern; find highest valid prefix:
                    // Check bits from top down for contiguous ones
                    if (sensors[0] == 1'b0) begin
                        // s[0] not asserted -> LEVEL0
                        decode_level = LEVEL0;
                    end else if (sensors[1] == 1'b0) begin
                        // s[0] asserted only -> LEVEL1
                        decode_level = LEVEL1;
                    end else if (sensors[2] == 1'b0) begin
                        // s[0] and s[1] asserted only -> LEVEL2
                        decode_level = LEVEL2;
                    end else begin
                        // Otherwise all asserted
                        decode_level = LEVEL3;
                    end
                end
            endcase
        end
    endfunction

    // Decode current sensors
    wire [1:0] decoded_level_wire = decode_level(s);

    // Sequential logic: update states on rising clock edge
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= LEVEL0;             // Reset to lowest level
            prev_state <= LEVEL0;
            last_level_before_change <= LEVEL0;
        end else begin
            prev_state <= curr_state;
            curr_state <= decoded_level_wire;

            // Update last_level_before_change only if water level changed
            if (decoded_level_wire != curr_state) begin
                last_level_before_change <= curr_state;
            end
            // else keep last_level_before_change unchanged
        end
    end

    // Nominal flow valve outputs per current water level state:
    // LEVEL3: fr0=0, fr1=0, fr2=0
    // LEVEL2: fr0=1, fr1=0, fr2=0
    // LEVEL1: fr0=1, fr1=1, fr2=0
    // LEVEL0: fr0=1, fr1=1, fr2=1

    reg fr0_reg, fr1_reg, fr2_reg, dfr_reg;
    always @(*) begin
        // Default to all valves closed
        fr0_reg = 1'b0;
        fr1_reg = 1'b0;
        fr2_reg = 1'b0;
        dfr_reg = 1'b0;

        case (curr_state)
            LEVEL3: begin
                fr0_reg = 1'b0; fr1_reg = 1'b0; fr2_reg = 1'b0;
            end
            LEVEL2: begin
                fr0_reg = 1'b1; fr1_reg = 1'b0; fr2_reg = 1'b0;
            end
            LEVEL1: begin
                fr0_reg = 1'b1; fr1_reg = 1'b1; fr2_reg = 1'b0;
            end
            LEVEL0: begin
                fr0_reg = 1'b1; fr1_reg = 1'b1; fr2_reg = 1'b1;
            end
            default: begin
                // Should never occur; default all valves closed
                fr0_reg = 1'b0; fr1_reg = 1'b0; fr2_reg = 1'b0;
            end
        endcase

        // Supplemental valve dfr asserted if current level > last_level_before_change
        if (curr_state > last_level_before_change) begin
            dfr_reg = 1'b1;
        end else begin
            dfr_reg = 1'b0;
        end
    end

    // On synchronous reset, outputs are all asserted (max flow)
    assign fr0 = reset ? 1'b1 : fr0_reg;
    assign fr1 = reset ? 1'b1 : fr1_reg;
    assign fr2 = reset ? 1'b1 : fr2_reg;
    assign dfr = reset ? 1'b1 : dfr_reg;

endmodule