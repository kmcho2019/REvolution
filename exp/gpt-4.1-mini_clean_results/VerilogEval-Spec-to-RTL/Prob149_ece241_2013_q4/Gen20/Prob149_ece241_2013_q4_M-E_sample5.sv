module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output      fr2,
    output      fr1,
    output      fr0,
    output      dfr
);

    // Define water level states as enumerated type for clarity
    typedef enum logic [1:0] {
        BELOW_S0        = 2'd0, // no sensors asserted
        BETWEEN_S1_S0   = 2'd1, // s[0] asserted only
        BETWEEN_S2_S1   = 2'd2, // s[0] and s[1] asserted (or only s[1]? see logic)
        ABOVE_S2        = 2'd3  // s[2] asserted (and s[0], s[1])
    } water_level_t;

    water_level_t curr_level, prev_level, next_level;

    // Decode sensor inputs into water level state
    function automatic water_level_t decode_level(input [2:0] sensors);
        // According to problem:
        // Above s[2]: s[0], s[1], s[2] asserted => ABOVE_S2
        // Between s[2] and s[1]: s[0], s[1] => BETWEEN_S2_S1
        // Between s[1] and s[0]: s[0] only => BETWEEN_S1_S0
        // Below s[0]: none asserted => BELOW_S0
        begin
            if (sensors == 3'b111) begin
                decode_level = ABOVE_S2;
            end else if (sensors == 3'b011) begin
                decode_level = BETWEEN_S2_S1;
            end else if (sensors == 3'b001) begin
                decode_level = BETWEEN_S1_S0;
            end else begin
                decode_level = BELOW_S0;
            end
        end
    endfunction

    // On reset initialize to lowest level (below s0)
    // On each clock, update states
    always_ff @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW_S0;
            prev_level <= BELOW_S0;
        end else begin
            curr_level <= decode_level(s);
            prev_level <= curr_level;
        end
    end

    // Compare levels for rising detection (dfr)
    // dfr = 1 if current > previous in level height order
    // Define explicit function for level ordering
    function automatic logic is_level_rising(water_level_t prev, water_level_t curr);
        begin
            is_level_rising = (curr > prev);
        end
    endfunction

    // Assign nominal flow outputs combinationally per current water level
    // Per problem:
    // ABOVE_S2: none asserted
    // BETWEEN_S2_S1: fr0
    // BETWEEN_S1_S0: fr0, fr1
    // BELOW_S0: fr0, fr1, fr2
    assign fr0 = (curr_level != ABOVE_S2);
    assign fr1 = (curr_level == BETWEEN_S1_S0) || (curr_level == BELOW_S0);
    assign fr2 = (curr_level == BELOW_S0);
    assign dfr = is_level_rising(prev_level, curr_level);

endmodule