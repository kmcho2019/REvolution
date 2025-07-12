module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Decode the water level from sensors input s
    // 3: 3'b111 - above s[2]
    // 2: 3'b011 - between s[2] and s[1]
    // 1: 3'b001 - between s[1] and s[0]
    // 0: else (including 3'b000) - below s[0]
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
            current_level <= 2'd0;  // lowest level on reset
            previous_level <= 2'd0;
            dfr <= 1'b1;            // supplemental valve open on reset (rising assumed)
        end else begin
            if (new_level != current_level) begin
                previous_level <= current_level;
                current_level <= new_level;
                // dfr asserted if level rising from previous_level to new_level
                dfr <= (new_level > previous_level) ? 1'b1 : 1'b0;
            end else begin
                dfr <= 1'b0; // no level change, no supplemental flow
            end
        end
    end

    // Nominal flow outputs based on current_level:
    // level 3 (above s[2]): no nominal valves open
    // level 2 (between s[2] and s[1]): fr0 open
    // level 1 (between s[1] and s[0]): fr0 and fr1 open
    // level 0 (below s[0]): fr0, fr1, fr2 open
    assign fr0 = (current_level != 2'd3);
    assign fr1 = (current_level <= 2'd1);
    assign fr2 = (current_level == 2'd0);

endmodule