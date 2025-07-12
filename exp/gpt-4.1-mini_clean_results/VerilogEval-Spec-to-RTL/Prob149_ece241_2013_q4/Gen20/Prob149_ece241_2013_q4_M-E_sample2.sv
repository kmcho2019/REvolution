module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level states as 2-bit enum:
    // 0 = below s[0]
    // 1 = between s[1] and s[0]
    // 2 = between s[2] and s[1]
    // 3 = above s[2]
    reg [1:0] prev_level;

    // Decode current water level from sensor pattern s
    // Valid sensor patterns:
    // s=3'b111 => level 3 (above s[2])
    // s=3'b011 => level 2 (between s[2] and s[1])
    // s=3'b001 => level 1 (between s[1] and s[0])
    // s=3'b000 => level 0 (below s[0])
    // Other patterns are mapped to nearest lower level by priority:
    // For stability, consider highest valid level ≤ pattern
    // Priority order: 3 (111), 2 (011), 1 (001), 0 (000)
    wire [1:0] current_level;
    assign current_level =
        (s == 3'b111) ? 2'd3 :
        (s == 3'b011) ? 2'd2 :
        (s == 3'b001) ? 2'd1 :
        (s == 3'b000) ? 2'd0 :
        // Map unknown patterns conservatively:
        // If s[2] asserted => at least level 2 or 3
        (s[2]) ? 2'd2 :
        // else if s[1] asserted => at least level 1 or 2
        (s[1]) ? 2'd1 :
        // else level 0
        2'd0;

    // Synchronous reset and level register update
    always @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;  // reset to lowest water level
        else
            prev_level <= current_level;
    end

    // dfr asserted if water level rose compared to previous level
    assign dfr = (current_level > prev_level);

    // Nominal flow outputs combinationally per water level
    // Level 3: fr0=0, fr1=0, fr2=0
    // Level 2: fr0=1, fr1=0, fr2=0
    // Level 1: fr0=1, fr1=1, fr2=0
    // Level 0: fr0=1, fr1=1, fr2=1
    assign {fr2, fr1, fr0} = (reset) ? 3'b111 : // On reset outputs all high per spec
                            (current_level == 2'd3) ? 3'b000 :
                            (current_level == 2'd2) ? 3'b001 :
                            (current_level == 2'd1) ? 3'b011 :
                                                      3'b111;

endmodule