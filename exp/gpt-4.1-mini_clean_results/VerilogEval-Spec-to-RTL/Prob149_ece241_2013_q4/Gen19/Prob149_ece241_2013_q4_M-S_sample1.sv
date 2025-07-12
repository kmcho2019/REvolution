module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Decode water level from sensors:
    // 3'b111 -> level 3 (above s[2])
    // 3'b011 -> level 2 (between s[2] and s[1])
    // 3'b001 -> level 1 (between s[1] and s[0])
    // others -> level 0 (below s[0])
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

    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;
            previous_level <= 2'd0;
            dfr <= 1'b1; // all valves open on reset (rising condition)
        end else begin
            previous_level <= current_level;
            current_level <= new_level;
            dfr <= (new_level > current_level); // supplemental flow if water level rising
        end
    end

    // Nominal flow valve outputs based on current_level:
    // Level 3: fr2=0, fr1=0, fr0=0
    // Level 2: fr2=0, fr1=0, fr0=1
    // Level 1: fr2=0, fr1=1, fr0=1
    // Level 0: fr2=1, fr1=1, fr0=1
    assign fr0 = (current_level != 2'd3);
    assign fr1 = (current_level <= 2'd1);
    assign fr2 = (current_level == 2'd0);

endmodule