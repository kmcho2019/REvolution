module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Decode sensor inputs into water level states:
    // 3: sensors s[2], s[1], s[0] asserted => above s[2]
    // 2: s[1] and s[0] asserted only      => between s[2] and s[1]
    // 1: s[0] asserted only               => between s[1] and s[0]
    // 0: no sensors asserted              => below s[0]
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = 2'd3;
                3'b011: decode_level = 2'd2;
                3'b001: decode_level = 2'd1;
                default: decode_level = 2'd0;
            endcase
        end
    endfunction

    reg [1:0] current_level;
    reg [1:0] previous_level;

    // Update water levels on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            // Reset to lowest water level and fully open valves
            current_level <= 2'd0;
            previous_level <= 2'd0;
        end else begin
            // If level changed, update previous_level before changing current_level
            if (decode_level(s) != current_level) begin
                previous_level <= current_level;
                current_level <= decode_level(s);
            end
            // else keep levels unchanged
        end
    end

    // Determine if water level rose compared to previous stable level
    wire level_rising = (current_level > previous_level);

    // Supplemental flow valve asserted only on rising water level transitions
    assign dfr = level_rising;

    // Nominal flow outputs according to the water level state
    // Level 3: above s[2], no nominal flow valves open
    // Level 2: between s[2] and s[1], fr0 open
    // Level 1: between s[1] and s[0], fr0 and fr1 open
    // Level 0: below s[0], fr0, fr1 and fr2 open
    assign fr0 = (current_level != 2'd3);
    assign fr1 = (current_level <= 2'd1);
    assign fr2 = (current_level == 2'd0);

endmodule