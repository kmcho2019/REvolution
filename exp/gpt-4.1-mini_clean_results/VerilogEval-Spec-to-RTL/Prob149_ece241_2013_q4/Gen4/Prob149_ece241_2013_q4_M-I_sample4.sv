module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Encode water level from sensors:
    // 0: no sensors asserted (below s0)
    // 1: only s0 asserted (between s1 and s0)
    // 2: s0 and s1 asserted (between s2 and s1)
    // 3: all sensors asserted (above s2)
    function [1:0] get_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: get_level = 2'd0;
                3'b001: get_level = 2'd1;
                3'b011: get_level = 2'd2;
                3'b111: get_level = 2'd3;
                default: get_level = 2'd0; // default to lowest level conservatively
            endcase
        end
    endfunction

    wire [1:0] curr_level = get_level(s);

    // Registers to hold water level history for previous stable level tracking
    reg [1:0] level_d1;    // previous cycle's level
    reg [1:0] prev_level;  // two cycles ago level

    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize to below s0 level (0)
            level_d1   <= 2'd0;
            prev_level <= 2'd0;
        end else begin
            level_d1   <= curr_level;
            prev_level <= level_d1;
        end
    end

    // Nominal flow outputs according to current level
    // Encoding nominal flows based on level:
    // level=3 (above s2): no flows
    // level=2 (between s2 and s1): fr0 only
    // level=1 (between s1 and s0): fr0 and fr1
    // level=0 (below s0): fr0, fr1, fr2 all on
    assign {fr2, fr1, fr0} = (curr_level == 2'd3) ? 3'b000 :
                            (curr_level == 2'd2) ? 3'b001 :
                            (curr_level == 2'd1) ? 3'b011 :
                            (curr_level == 2'd0) ? 3'b111 :
                            3'b111; // default conservative if unexpected

    // Supplemental flow valve is opened if current level > previous level before last change
    assign dfr = (curr_level > prev_level) ? 1'b1 : 1'b0;

endmodule