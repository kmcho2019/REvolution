module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // FSM states representing water levels
    typedef enum logic [1:0] {
        LEVEL0 = 2'd0,  // below s[0], no sensors asserted
        LEVEL1 = 2'd1,  // s[0] asserted only
        LEVEL2 = 2'd2,  // s[0] and s[1] asserted
        LEVEL3 = 2'd3   // all s[0], s[1], s[2] asserted
    } level_t;

    level_t curr_state, next_state;
    level_t prev_state;

    // Decode sensor pattern into a level state
    // Logic:
    // Check from bottom sensor upwards:
    // LEVEL3 if s == 3'b111
    // LEVEL2 if s[0] & s[1] asserted and s[2] not asserted
    // LEVEL1 if only s[0] asserted
    // LEVEL0 if none asserted
    // If pattern invalid (non-contiguous asserted sensors), choose highest level consistent:
    function level_t decode_level(input [2:0] sensors);
        begin
            // Check for all sensors asserted
            if (sensors == 3'b111) begin
                decode_level = LEVEL3;
            end
            // Check for s[0] and s[1] asserted, s[2] not asserted
            else if ((sensors[1:0] == 2'b11) && (sensors[2] == 1'b0)) begin
                decode_level = LEVEL2;
            end
            // Check for only s[0] asserted (and s[1], s[2] zero)
            else if ((sensors[0] == 1'b1) && (sensors[2:1] == 2'b00)) begin
                decode_level = LEVEL1;
            end
            // Check for no sensors asserted
            else if (sensors == 3'b000) begin
                decode_level = LEVEL0;
            end
            else begin
                // Handle invalid patterns:
                // Find highest contiguous level consistent with sensors asserted from bottom up
                // Priority: check LEVEL3 -> LEVEL2 -> LEVEL1 -> LEVEL0
                if (sensors[2]) decode_level = LEVEL3;
                else if (sensors[1]) decode_level = LEVEL2;
                else if (sensors[0]) decode_level = LEVEL1;
                else decode_level = LEVEL0;
            end
        end
    endfunction

    wire level_t curr_level = decode_level(s);

    // Sequential logic: Update FSM state and previous state
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= LEVEL0;
            prev_state <= LEVEL0;
        end else begin
            prev_state <= curr_state;
            curr_state <= curr_level;
        end
    end

    // Output logic for nominal flow valves
    // LEVEL3: fr0=0, fr1=0, fr2=0
    // LEVEL2: fr0=1, fr1=0, fr2=0
    // LEVEL1: fr0=1, fr1=1, fr2=0
    // LEVEL0: fr0=1, fr1=1, fr2=1
    wire fr0_nominal = (curr_state <= LEVEL2);
    wire fr1_nominal = (curr_state <= LEVEL1);
    wire fr2_nominal = (curr_state == LEVEL0);

    // Supplemental flow valve (dfr) active if current level is higher than previous level (rising water)
    wire dfr_nominal = (curr_state > prev_state);

    // On reset, outputs asserted (all valves open including supplemental valve)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_nominal;

endmodule