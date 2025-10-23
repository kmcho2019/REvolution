module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Decode water level from sensor input s (3 bits)
    // Levels: 0=below s[0], 1=between s[1] and s[0], 2=between s[2] and s[1], 3=above s[2]
    // Map sensor inputs to these levels as described.
    function [1:0] decode_level;
        input [2:0] ss;
        begin
            case (ss)
                3'b111: decode_level = 2'd3;
                3'b011: decode_level = 2'd2;
                3'b001: decode_level = 2'd1;
                3'b000: decode_level = 2'd0;
                default: begin
                    if (ss[2]) decode_level = 2'd3;
                    else if (ss[1]) decode_level = 2'd2;
                    else if (ss[0]) decode_level = 2'd1;
                    else decode_level = 2'd0;
                end
            endcase
        end
    endfunction

    wire [1:0] curr_level;
    reg  [1:0] prev_level;

    assign curr_level = decode_level(s);

    // On clock edge, update prev_level with curr_level.
    // On reset, prev_level = 0 (lowest level)
    always @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;
        else
            prev_level <= curr_level;
    end

    // Nominal flow valves outputs according to current level:
    // above s[2] (3): no nominal flow (all zero)
    // between s[2] and s[1] (2): fr0 only
    // between s[1] and s[0] (1): fr0 and fr1
    // below s[0] (0): fr0, fr1, fr2
    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental flow valve dfr:
    // Asserted if water level rising: curr_level > prev_level
    // During reset, all valves including dfr asserted
    wire dfr_int = (curr_level > prev_level) ? 1'b1 : 1'b0;

    // Outputs with synchronous reset override all outputs high (all valves open)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule