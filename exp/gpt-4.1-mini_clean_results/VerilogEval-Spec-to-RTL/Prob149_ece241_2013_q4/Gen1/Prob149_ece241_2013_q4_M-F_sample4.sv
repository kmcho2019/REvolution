module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Decode current water level from sensors s:
    // Level codes:
    // 3 = above s[2] (all 3 sensors asserted)
    // 2 = between s[2] and s[1] (s[0]=1, s[1]=1, s[2]=0 or similar)
    // 1 = between s[1] and s[0] (only s[0] asserted)
    // 0 = below s[0] (no sensors asserted)
    // Others map to nearest level based on highest asserted sensor.

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

    reg [1:0] prev_level;      // water level before last change
    reg [1:0] curr_level_reg;  // water level sampled on previous clock cycle

    wire [1:0] curr_level = decode_level(s);

    // On clock edge:
    // If level changed (curr_level != curr_level_reg),
    // update prev_level to curr_level_reg (previous level)
    // Then update curr_level_reg to curr_level (new level)

    always @(posedge clk) begin
        if (reset) begin
            prev_level     <= 2'd0;  // low water level on reset
            curr_level_reg <= 2'd0;
        end else begin
            if (curr_level != curr_level_reg)
                prev_level <= curr_level_reg;
            curr_level_reg <= curr_level;
        end
    end

    // Outputs nominal flow valves based on current level (curr_level_reg):

    // Mapping from problem:
    // Above s[2] (3): no nominal flows asserted
    // Between s[2] and s[1] (2): fr0
    // Between s[1] and s[0] (1): fr0, fr1
    // Below s[0] (0): fr0, fr1, fr2

    wire fr0_w = (curr_level_reg <= 2'd2);
    wire fr1_w = (curr_level_reg <= 2'd1);
    wire fr2_w = (curr_level_reg == 2'd0);

    // Supplemental flow valve: asserted if water level rising (curr_level_reg > prev_level)
    // On reset, dfr asserted as per requirement

    wire dfr_w = (curr_level_reg > prev_level);

    assign fr0 = reset ? 1'b1 : fr0_w;
    assign fr1 = reset ? 1'b1 : fr1_w;
    assign fr2 = reset ? 1'b1 : fr2_w;
    assign dfr = reset ? 1'b1 : dfr_w;

endmodule