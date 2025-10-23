module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water levels encoding
    // 0 = BELOW (no sensors asserted)
    // 1 = LOW   (only lowest sensor s[0] asserted)
    // 2 = MID   (lowest s[0] and middle s[1] asserted)
    // 3 = ABOVE (all three sensors s[0], s[1], s[2] asserted)
    // We determine level by counting how many sensors are asserted starting from lowest
    // This naturally covers all sensor input combinations.
    reg [1:0] curr_level, prev_level;

    // Function to count asserted sensors from lowest to highest (i.e. how many bottom sensors are asserted)
    // Since sensors are vertical and at 5" intervals, and higher sensors imply lower ones are also asserted if water is above.
    // Therefore, we interpret the water level as number of contiguous asserted sensors starting from s[0].
    // Example:
    // s=3'b000 => level=0 (BELOW)
    // s=3'b001 => level=1 (LOW)
    // s=3'b011 => level=2 (MID)
    // s=3'b111 => level=3 (ABOVE)
    // Any non-contiguous patterns like s=3'b101 or s=3'b010 are treated as the highest contiguous prefix.
    // So we decode level by counting how many contiguous asserted sensors starting at s[0].
    function [1:0] decode_level;
        input [2:0] s_in;
        begin
            if (s_in[0] == 1'b0)
                decode_level = 2'd0; // no sensor asserted => BELOW
            else if (s_in[1] == 1'b0)
                decode_level = 2'd1; // only lowest sensor asserted => LOW
            else if (s_in[2] == 1'b0)
                decode_level = 2'd2; // lowest and middle asserted => MID
            else
                decode_level = 2'd3; // all sensors asserted => ABOVE
        end
    endfunction

    wire [1:0] next_level = decode_level(s);

    wire level_changed = (next_level != curr_level);
    wire level_rising = level_changed && (next_level > curr_level);

    // State update synchronous with clock
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0; // BELOW on reset
            prev_level <= 2'd0; // BELOW on reset
        end else begin
            if (level_changed)
                prev_level <= curr_level;
            curr_level <= next_level;
        end
    end

    // Nominal flow outputs combinational based on curr_level
    // ABOVE (3): fr2=0, fr1=0, fr0=0
    // MID   (2): fr2=0, fr1=0, fr0=1
    // LOW   (1): fr2=0, fr1=1, fr0=1
    // BELOW (0): fr2=1, fr1=1, fr0=1
    always @(*) begin
        case (curr_level)
            2'd3: begin // ABOVE
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
            end
            2'd2: begin // MID
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
            end
            2'd1: begin // LOW
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
            default: begin // BELOW or any other unrecognized pattern
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
        endcase
    end

    // Supplemental flow valve dfr register update synchronous with clock
    // Asserted if water level is rising (current level > previous level on level change)
    always @(posedge clk) begin
        if (reset) begin
            dfr <= 1'b1; // asserted on reset per spec
        end else begin
            dfr <= level_rising ? 1'b1 : 1'b0;
        end
    end

endmodule