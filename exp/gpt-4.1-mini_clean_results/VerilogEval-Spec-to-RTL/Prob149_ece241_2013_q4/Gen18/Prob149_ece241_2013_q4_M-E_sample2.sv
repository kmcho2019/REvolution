module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding:
    // 3: all sensors asserted (above s[2])
    // 2: s[0] and s[1] asserted only (between s[2] and s[1])
    // 1: s[0] only asserted (between s[1] and s[0])
    // 0: no sensors asserted (below s[0])
    // Note: Sensors must follow the given pattern exactly for levels 1 and 2,
    // otherwise treat as 0 (lowest).

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

    reg [1:0] current_level, previous_level;
    wire [1:0] new_level = decode_level(s);

    // State update and supplemental valve logic
    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;
            previous_level <= 2'd0;
            dfr <= 1'b1; // open supplemental valve on reset (rising condition assumed)
        end else begin
            if (new_level != current_level) begin
                previous_level <= current_level;
                current_level <= new_level;
                dfr <= (new_level > current_level); // rising if new level > old current
            end else begin
                dfr <= 1'b0; // no change means no supplemental flow
            end
        end
    end

    // Nominal flow valve outputs per level (according to table):
    // Level 3 (above s[2]) - fr2=0, fr1=0, fr0=0
    // Level 2 (between s[2] and s[1]) - fr0=1, fr1=0, fr2=0
    // Level 1 (between s[1] and s[0]) - fr0=1, fr1=1, fr2=0
    // Level 0 (below s[0]) - fr0=1, fr1=1, fr2=1

    assign fr0 = (current_level != 2'd3);         // fr0 on for levels 0,1,2
    assign fr1 = (current_level <= 2'd1);         // fr1 on for levels 0,1
    assign fr2 = (current_level == 2'd0);         // fr2 on only for level 0

endmodule