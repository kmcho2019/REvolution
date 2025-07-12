module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Enumerate water level states
    typedef enum logic [1:0] {
        LEVEL_0 = 2'd0, // Below s[0]: no sensors asserted
        LEVEL_1 = 2'd1, // Between s[0] and s[1]: only s[0] asserted
        LEVEL_2 = 2'd2, // Between s[1] and s[2]: s[0] and s[1] asserted
        LEVEL_3 = 2'd3  // Above s[2]: s[0], s[1], s[2] asserted
    } level_t;

    // Function to decode sensor input into water level state, enforcing contiguous sensors bottom-up
    function level_t decode_level(input [2:0] sensors);
        begin
            // Normalize sensors to valid contiguous pattern bottom-up
            if (sensors == 3'b111) begin
                decode_level = LEVEL_3;
            end else if (sensors[1:0] == 2'b11 && sensors[2]==0) begin
                decode_level = LEVEL_2;
            end else if (sensors[0] == 1 && sensors[1] == 0) begin
                decode_level = LEVEL_1;
            end else begin
                // Any other pattern including no sensors asserted => LEVEL_0
                decode_level = LEVEL_0;
            end
        end
    endfunction

    // Registers to store current level, previous level, and last level at change
    level_t current_level, previous_level, last_level_at_change;

    always @(posedge clk) begin
        if (reset) begin
            current_level       <= LEVEL_0;
            previous_level      <= LEVEL_0;
            last_level_at_change <= LEVEL_0;
        end else begin
            // Decode current sensor input into water level
            level_t new_level = decode_level(s);

            previous_level <= current_level;
            current_level <= new_level;

            // Update last_level_at_change on any level change
            if (new_level != current_level)
                last_level_at_change <= current_level;
        end
    end

    // Output logic combinationally derived from current level and last_level_at_change

    // Nominal flow valves logic:
    // LEVEL_3: fr0=fr1=fr2=0
    // LEVEL_2: fr0=1; fr1=fr2=0
    // LEVEL_1: fr0=fr1=1; fr2=0
    // LEVEL_0: fr0=fr1=fr2=1

    wire fr0_val, fr1_val, fr2_val, dfr_val;

    assign fr0_val = (current_level == LEVEL_0) || (current_level == LEVEL_1) || (current_level == LEVEL_2);
    assign fr1_val = (current_level == LEVEL_0) || (current_level == LEVEL_1);
    assign fr2_val = (current_level == LEVEL_0);

    // Supplemental flow valve (dfr) open if water level rose compared to last level at last change
    assign dfr_val = (current_level > last_level_at_change);

    // Output assignment with reset forcing max flow per spec
    assign fr0 = reset ? 1'b1 : fr0_val;
    assign fr1 = reset ? 1'b1 : fr1_val;
    assign fr2 = reset ? 1'b1 : fr2_val;
    assign dfr = reset ? 1'b1 : dfr_val;

endmodule