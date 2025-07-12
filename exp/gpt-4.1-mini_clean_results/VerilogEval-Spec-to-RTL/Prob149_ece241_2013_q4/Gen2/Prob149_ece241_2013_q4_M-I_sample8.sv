module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding:
    // 3 = above s[2] (s == 3'b111)
    // 2 = between s[2] and s[1] (s == 3'b011)
    // 1 = between s[1] and s[0] (s == 3'b001)
    // 0 = below s[0] (s == 3'b000)
    // Any other combination: map to the nearest valid lower level (or treat as below s[0])

    function [1:0] decode_level(input [2:0] ss);
        begin
            case (ss)
                3'b111: decode_level = 2'd3;
                3'b011: decode_level = 2'd2;
                3'b001: decode_level = 2'd1;
                3'b000: decode_level = 2'd0;
                default: decode_level = 2'd0; // treat invalid as lowest level
            endcase
        end
    endfunction

    reg  [2:0] prev_s;       // previous sensor state for detecting change
    reg  [1:0] prev_level;   // water level before last sensor change

    wire [1:0] curr_level = decode_level(s);
    wire       sensors_changed = (s != prev_s);

    always @(posedge clk) begin
        if (reset) begin
            prev_s     <= 3'b000;   // reset sensors to no assertion
            prev_level <= 2'd0;     // reset previous level to lowest
        end else begin
            prev_s <= s;
            if (sensors_changed)
                prev_level <= decode_level(prev_s);
            // else prev_level holds its value
        end
    end

    // Nominal flow valves outputs based on current level:
    // level 3: no nominal flow (all zero)
    // level 2: fr0 only
    // level 1: fr0 and fr1
    // level 0: fr0, fr1, fr2
    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental flow valve dfr: asserted if current level > previous level (rising water)
    wire dfr_int = (curr_level > prev_level);

    // On reset, all valves including dfr asserted (1)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule