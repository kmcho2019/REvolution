module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoded as:
    // 0 = below s[0]       (s=000)
    // 1 = between s[1] and s[0] (s=001)
    // 2 = between s[2] and s[1] (s=011)
    // 3 = above s[2]       (s=111)
    //
    // Any other pattern, map to closest:
    // if s[2]==1 => level=3
    // else if s[1]==1 => level=2
    // else if s[0]==1 => level=1
    // else level=0

    reg [1:0] prev_level;
    reg [2:0] prev_s;

    wire [1:0] curr_level;
    wire s_changed;

    // Decode current level from s
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

    assign curr_level = decode_level(s);
    assign s_changed = (s != prev_s);

    // On synchronous clock, update prev_s and prev_level on sensor changes
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0; // Equivalent to low water level for long time
            prev_s <= 3'b000;
        end else begin
            if (s_changed) begin
                // Update prev_level to old level before sensor change
                prev_level <= decode_level(prev_s);
                prev_s <= s;
            end else begin
                prev_s <= s;
            end
        end
    end

    // Outputs according to current level
    // Nominal flow valve outputs fr0, fr1, fr2:
    // above s[2] (3): no fr outputs asserted
    // between s[2] and s[1] (2): fr0
    // between s[1] and s[0] (1): fr0, fr1
    // below s[0] (0): fr0, fr1, fr2

    wire fr0_w, fr1_w, fr2_w, dfr_w;

    assign fr0_w = (curr_level <= 2'd2); // fr0 asserted except above s[2]
    assign fr1_w = (curr_level <= 2'd1); // fr1 asserted between s[1] and s[0] and below s[0]
    assign fr2_w = (curr_level == 2'd0); // fr2 asserted only below s[0]

    // Supplemental flow valve (dfr) asserted if water level rising (current > previous)
    // Also on reset, dfr asserted
    assign dfr_w = (reset) ? 1'b1 : ((curr_level > prev_level) ? 1'b1 : 1'b0);

    // Special case on reset: override outputs to all ones (all flow valves open)
    // We can implement outputs as registers or wires with mux, simpler is wires with mux.

    assign fr0 = (reset) ? 1'b1 : fr0_w;
    assign fr1 = (reset) ? 1'b1 : fr1_w;
    assign fr2 = (reset) ? 1'b1 : fr2_w;
    assign dfr = (reset) ? 1'b1 : dfr_w;

endmodule