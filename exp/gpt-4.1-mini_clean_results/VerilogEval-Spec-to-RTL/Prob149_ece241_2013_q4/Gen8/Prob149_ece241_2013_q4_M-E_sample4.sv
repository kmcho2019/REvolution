module TopModule (
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output reg    dfr
);

    // Water level encoding:
    // 0: below s[0] (no sensors)
    // 1: between s[1] and s[0] (only s[0])
    // 2: between s[2] and s[1] (s[0] and s[1])
    // 3: above s[2] (s[0], s[1], s[2])
    reg [1:0] curr_level, prev_level;

    // Combinational sensor decoding function
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_level = 2'd0; // Below s[0]
                3'b001: decode_level = 2'd1; // Between s[1] and s[0]
                3'b011: decode_level = 2'd2; // Between s[2] and s[1]
                3'b111: decode_level = 2'd3; // Above s[2]
                default: decode_level = 2'd0; // Treat unexpected as below s[0]
            endcase
        end
    endfunction

    // Nominal flow valve outputs (combinational)
    assign fr2 = (curr_level == 2'd0) ? 1'b1 : 1'b0;
    assign fr1 = (curr_level == 2'd0 || curr_level == 2'd1) ? 1'b1 : 1'b0;
    assign fr0 = (curr_level != 2'd3) ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0; // Below s[0]
            prev_level <= 2'd0;
            dfr        <= 1'b1; // Assert supplemental flow on reset as specified
        end else begin
            prev_level <= curr_level;
            curr_level <= decode_level(s);

            // dfr asserted for one cycle when water level rises
            dfr <= (decode_level(s) > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule