module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Decode water level from sensor pattern s:
    // 3'b111 -> Above s[2]
    // 3'b011 -> Between s[2] and s[1]
    // 3'b001 -> Between s[1] and s[0]
    // 3'b000 -> Below s[0]
    // Other patterns not explicitly defined; treat conservatively as closest lower level.

    // Define water level encoding:
    // 3: above s[2]
    // 2: between s[2] and s[1]
    // 1: between s[1] and s[0]
    // 0: below s[0]

    reg [2:0] prev_s;

    // Function to decode water level from sensor input
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = 2'd3; // above s[2]
                3'b011: decode_level = 2'd2; // between s[2] and s[1]
                3'b001: decode_level = 2'd1; // between s[1] and s[0]
                3'b000: decode_level = 2'd0; // below s[0]
                // For other patterns, assign to closest lower level:
                3'b010: decode_level = 2'd1; // treat as between s[1] and s[0]
                3'b110: decode_level = 2'd2; // treat as between s[2] and s[1]
                3'b100: decode_level = 2'd1; // treat as between s[1] and s[0]
                3'b101: decode_level = 2'd2; // treat as between s[2] and s[1]
                default: decode_level = 2'd0; // fallback below s[0]
            endcase
        end
    endfunction

    wire [1:0] curr_level = decode_level(s);
    wire [1:0] prev_level = decode_level(prev_s);

    // Detect if level increased compared to previous sensor pattern
    wire level_rising = (curr_level > prev_level);

    // Synchronous logic: update prev_s and dfr
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;   // no sensors asserted (below s[0])
            dfr <= 1'b1;        // supplemental valve open on reset
        end else begin
            dfr <= level_rising ? 1'b1 : 1'b0;
            prev_s <= s;
        end
    end

    // Nominal flow valve outputs derived combinationally from current level:
    // Above s[2] (3): no nominal valves asserted
    // Between s[2] and s[1] (2): fr0 only
    // Between s[1] and s[0] (1): fr0 and fr1
    // Below s[0] (0): fr0, fr1, fr2

    assign fr0 = (curr_level != 2'd3);
    assign fr1 = (curr_level <= 2'd1);
    assign fr2 = (curr_level == 2'd0);

endmodule