module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [2:0]  s,
    output reg         fr2,
    output reg         fr1,
    output reg         fr0,
    output reg         dfr
);

// Define water level states based on sensor inputs
// We'll map sensor patterns to levels:
// 3'b111: above s[2]
// 3'b110: between s[2] and s[1]
// 3'b100: between s[1] and s[0]
// 3'b000: below s[0]
// Other patterns treated as stable or mapped to closest known state

typedef enum reg [1:0] {
    BELOW_S0 = 2'd0,
    BETWEEN_S1_S0 = 2'd1,
    BETWEEN_S2_S1 = 2'd2,
    ABOVE_S2 = 2'd3
} water_level_t;

reg [1:0] current_level, prev_level;

// Function to decode sensor input to water_level_t
function water_level_t decode_level(input [2:0] sensors);
    begin
        case (sensors)
            3'b111: decode_level = ABOVE_S2;
            3'b110: decode_level = BETWEEN_S2_S1;
            3'b100: decode_level = BETWEEN_S1_S0;
            3'b000: decode_level = BELOW_S0;
            default: begin
                // For unspecified patterns, choose closest:
                // If s[2] asserted => ABOVE_S2
                // else if s[1] asserted => BETWEEN_S2_S1
                // else if s[0] asserted => BETWEEN_S1_S0
                // else BELOW_S0
                if (sensors[2]) decode_level = ABOVE_S2;
                else if (sensors[1]) decode_level = BETWEEN_S2_S1;
                else if (sensors[0]) decode_level = BETWEEN_S1_S0;
                else decode_level = BELOW_S0;
            end
        endcase
    end
endfunction

// Determine if level has risen: previous level < current level
function level_risen(input water_level_t prev, input water_level_t curr);
    begin
        level_risen = (curr > prev);
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level low for a long time:
        // no sensors asserted, all flow outputs asserted
        prev_level <= BELOW_S0;
        current_level <= BELOW_S0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        current_level <= decode_level(s);
        // Determine nominal flow outputs based on current_level
        case (current_level)
            ABOVE_S2: begin
                // Above s[2]: no nominal flow
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            BETWEEN_S2_S1: begin
                // Between s[2] and s[1]: fr0 only
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            BETWEEN_S1_S0: begin
                // Between s[1] and s[0]: fr0, fr1
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            BELOW_S0: begin
                // Below s[0]: fr0, fr1, fr2
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                // Default to safe: all off
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
        endcase

        // Determine if supplemental flow valve (dfr) should be asserted
        // dfr asserted if water level has risen since last sensor change
        if (level_risen(prev_level, current_level))
            dfr <= 1'b1;
        else
            dfr <= 1'b0;

        // Update previous level for next cycle
        prev_level <= current_level;
    end
end

endmodule