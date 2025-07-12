module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Enumerate water level states
    typedef enum reg [1:0] {
        BELOW    = 2'd0,  // no sensors asserted: 3'b000
        BETWEEN0 = 2'd1,  // s[0] asserted only: 3'b001
        BETWEEN1 = 2'd2,  // s[0], s[1] asserted: 3'b011
        ABOVE    = 2'd3   // all sensors asserted: 3'b111
    } level_t;

    reg [2:0] s_reg;
    reg [1:0] curr_level, prev_level;

    // Decode the sensor input to water level exactly per spec
    function level_t decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE;
                3'b011: decode_level = BETWEEN1; // s[1] and s[0]
                3'b001: decode_level = BETWEEN0; // s[0] only
                3'b000: decode_level = BELOW;    // none asserted
                default: decode_level = BELOW;   // treat other cases as BELOW for safety
            endcase
        end
    endfunction

    // Store current sensors synchronously for stable decoding and timing alignment
    always @(posedge clk) begin
        if (reset) begin
            s_reg <= 3'b000;
        end else begin
            s_reg <= s;
        end
    end

    wire level_changed;
    wire level_rising;
    level_t next_level;

    // Decode next level combinationally from registered sensor input
    assign next_level = decode_level(s_reg);

    assign level_changed = (next_level != curr_level);
    assign level_rising = level_changed && (next_level > prev_level);

    // Update current and previous levels synchronously
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            if (level_changed) begin
                // On change, update prev_level to old curr_level
                prev_level <= curr_level;
                curr_level <= next_level;
            end else begin
                // No level change, keep prev_level, update curr_level to next_level (to reflect current sensor)
                curr_level <= next_level;
                // prev_level unchanged
            end
        end
    end

    // Outputs nominal flow valves per spec:
    // Above: no valves (fr0=0, fr1=0, fr2=0)
    // Between s[2] and s[1] (BETWEEN1): fr0=1 only
    // Between s[1] and s[0] (BETWEEN0): fr0=1, fr1=1
    // Below s[0] (BELOW): fr0=1, fr1=1, fr2=1

    wire nominal_fr0 = (curr_level != ABOVE);
    wire nominal_fr1 = (curr_level == BETWEEN0) || (curr_level == BELOW);
    wire nominal_fr2 = (curr_level == BELOW);

    // Supplemental flow valve dfr asserted on rising level
    wire supplemental_dfr = level_rising;

    // Outputs asserted during reset as per spec (all valves open)
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule