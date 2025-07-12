module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output reg    dfr
);

    reg [1:0] prev_level, current_level;

    // Decode sensor inputs to numeric level (combinational)
    // 0 = below s[0], 1 = s[0] only, 2 = s[0] and s[1], 3 = all three sensors
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = 2'd3;
                3'b011: decode_level = 2'd2;
                3'b001: decode_level = 2'd1;
                default: decode_level = 2'd0;
            endcase
        end
    endfunction

    wire [1:0] new_level = decode_level(s);

    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;   // lowest water level
            prev_level <= 2'd0;
            dfr <= 1'b1;             // supplemental flow valve open on reset
        end else begin
            prev_level <= current_level;
            current_level <= new_level;
            dfr <= (new_level > current_level) ? 1'b1 : 1'b0;
        end
    end

    assign fr0 = (current_level != 2'd3);
    assign fr1 = (current_level == 2'd1) || (current_level == 2'd0);
    assign fr2 = (current_level == 2'd0);

endmodule