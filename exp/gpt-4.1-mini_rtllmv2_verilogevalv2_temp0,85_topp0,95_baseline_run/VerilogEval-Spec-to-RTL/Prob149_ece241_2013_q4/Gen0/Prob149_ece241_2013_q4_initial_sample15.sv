module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding:
    // 0 = below s[0] (s == 3'b000)
    // 1 = between s[1] and s[0] (s == 3'b001)
    // 2 = between s[2] and s[1] (s == 3'b011)
    // 3 = above s[2] (s == 3'b111)
    // All other sensor combinations treated as closest lower level or ignored (not specified).
    // We'll only consider these 4 states as valid levels for the logic.

    reg [1:0] prev_level;

    // Function to decode current sensor reading to level state
    function [1:0] decode_level;
        input [2:0] s_in;
        begin
            case (s_in)
                3'b000: decode_level = 2'd0; // below s[0]
                3'b001: decode_level = 2'd1; // between s[1] and s[0]
                3'b011: decode_level = 2'd2; // between s[2] and s[1]
                3'b111: decode_level = 2'd3; // above s[2]
                // For other combinations, choose closest level down:
                3'b010: decode_level = 2'd1; // treat as between s[1] and s[0]
                3'b100: decode_level = 2'd2; // treat as between s[2] and s[1]
                3'b101: decode_level = 2'd2; // treat as between s[2] and s[1]
                3'b110: decode_level = 2'd2; // treat as between s[2] and s[1]
                default: decode_level = 2'd0; // default to lowest level
            endcase
        end
    endfunction

    wire [1:0] current_level = decode_level(s);

    // Detect if level has risen relative to previous
    // rising = current_level > prev_level
    wire level_rising = (current_level > prev_level);

    // Sequential logic: update prev_level on clk
    always @(posedge clk) begin
        if (reset) begin
            // Reset to state equivalent to low water level for long time:
            prev_level <= 2'd0;
        end else begin
            // Update prev_level only if level changes
            if (current_level != prev_level) begin
                prev_level <= current_level;
            end
        end
    end

    // Output logic based on current level and rising condition
    // Nominal flow rates:
    // Above s[2] (3): no valves open
    // Between s[2] and s[1] (2): fr0 = 1
    // Between s[1] and s[0] (1): fr0=1, fr1=1
    // Below s[0] (0): fr0=1, fr1=1, fr2=1

    // Supplemental flow valve (dfr) open if rising

    reg fr0_reg, fr1_reg, fr2_reg, dfr_reg;

    always @(*) begin
        // default all off
        fr0_reg = 0;
        fr1_reg = 0;
        fr2_reg = 0;
        dfr_reg = 0;

        case (current_level)
            2'd3: begin
                // Above s[2]
                // no valves open
                fr0_reg = 0;
                fr1_reg = 0;
                fr2_reg = 0;
                dfr_reg = 0;
            end
            2'd2: begin
                // Between s[2] and s[1]
                fr0_reg = 1;
                fr1_reg = 0;
                fr2_reg = 0;
                dfr_reg = level_rising ? 1 : 0;
            end
            2'd1: begin
                // Between s[1] and s[0]
                fr0_reg = 1;
                fr1_reg = 1;
                fr2_reg = 0;
                dfr_reg = level_rising ? 1 : 0;
            end
            2'd0: begin
                // Below s[0]
                fr0_reg = 1;
                fr1_reg = 1;
                fr2_reg = 1;
                dfr_reg = level_rising ? 1 : 0;
            end
            default: begin
                fr0_reg = 0;
                fr1_reg = 0;
                fr2_reg = 0;
                dfr_reg = 0;
            end
        endcase

        // On reset, outputs should be all asserted:
        // This is handled by prev_level initialization and combinational logic
        // when reset is active, outputs are forced outside sequential block
    end

    // Override outputs when reset asserted synchronously
    assign fr0 = reset ? 1'b1 : fr0_reg;
    assign fr1 = reset ? 1'b1 : fr1_reg;
    assign fr2 = reset ? 1'b1 : fr2_reg;
    assign dfr = reset ? 1'b1 : dfr_reg;

endmodule