module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water levels:
    // 3 = above s[2]  (s == 3'b111)
    // 2 = between s[2] and s[1] (s == 3'b011)
    // 1 = between s[1] and s[0] (s == 3'b001)
    // 0 = below s[0] (s == 3'b000)
    // Other patterns considered invalid -> treat as previous level unchanged, outputs driven by current

    reg [1:0] curr_level;
    reg [1:0] prev_level;
    reg [2:0] last_s;  // store previous sensor input to detect changes

    // Decode water level from sensor input s (only four valid patterns)
    function [1:0] decode_level;
        input [2:0] ss;
        begin
            case (ss)
                3'b111: decode_level = 2'd3;
                3'b011: decode_level = 2'd2;
                3'b001: decode_level = 2'd1;
                3'b000: decode_level = 2'd0;
                default: decode_level = 2'bx; // invalid pattern
            endcase
        end
    endfunction

    wire [1:0] decoded_level = decode_level(s);

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0;    // low water level at reset
            prev_level <= 2'd0;
            last_s <= 3'b000;
        end else begin
            if (s != last_s) begin
                // Sensor changed, update previous level to old current_level, then update current_level
                prev_level <= curr_level;
                // If new s is invalid, keep current_level unchanged to avoid invalid states
                if (decoded_level !== 2'bx)
                    curr_level <= decoded_level;
                // else curr_level unchanged
                last_s <= s;
            end else begin
                // no sensor change, keep previous level same
                last_s <= last_s;
                // curr_level unchanged
            end
        end
    end

    // Nominal flow valve outputs by current water level
    // Above s[2] (3): none asserted
    // Between s[2] and s[1] (2): fr0
    // Between s[1] and s[0] (1): fr0, fr1
    // Below s[0] (0): fr0, fr1, fr2
    wire fr0_nom = (curr_level <= 2'd2);
    wire fr1_nom = (curr_level <= 2'd1);
    wire fr2_nom = (curr_level == 2'd0);

    // Supplemental flow valve: asserted if water level rising (current > previous)
    wire dfr_int = (curr_level > prev_level);

    // On reset outputs asserted (all valves open)
    assign fr0 = reset ? 1'b1 : fr0_nom;
    assign fr1 = reset ? 1'b1 : fr1_nom;
    assign fr2 = reset ? 1'b1 : fr2_nom;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule