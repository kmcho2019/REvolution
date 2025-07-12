module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Decode water level strictly according to problem spec
    // 3'b111 -> 3 (above s[2])
    // 3'b011 -> 2 (between s[2] and s[1])
    // 3'b001 -> 1 (between s[1] and s[0])
    // 3'b000 -> 0 (below s[0])
    // Other patterns mapped to 0 (lowest level) for safety.
    function [1:0] decode_level;
        input [2:0] ss;
        begin
            case (ss)
                3'b111: decode_level = 2'd3;
                3'b011: decode_level = 2'd2;
                3'b001: decode_level = 2'd1;
                3'b000: decode_level = 2'd0;
                default: decode_level = 2'd0; // fallback for invalid patterns
            endcase
        end
    endfunction

    // Registers to store previous sensor inputs and previous level before last sensor change
    reg [2:0] prev_s;
    reg [1:0] prev_level;

    wire [1:0] curr_level = decode_level(s);

    // Detect sensor change by comparing current sensor inputs to previous sensor inputs
    wire sensor_change = (s != prev_s);

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;        // no sensors asserted => lowest level
            prev_level <= 2'd0;      // lowest level
        end else begin
            prev_s <= s;
            // Update prev_level only on sensor change
            if (sensor_change)
                prev_level <= curr_level;
            // else keep prev_level unchanged
        end
    end

    // Nominal flow valves outputs according to current level:
    // Above s[2] (3): none asserted
    // Between s[2] and s[1] (2): fr0 only
    // Between s[1] and s[0] (1): fr0 and fr1
    // Below s[0] (0): fr0, fr1, fr2
    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental flow valve dfr asserted if water level rising compared to previous level before last sensor change
    wire dfr_int = (curr_level > prev_level);

    // Outputs: synchronous reset forces all valves open (asserted)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule