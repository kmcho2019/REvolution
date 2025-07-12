module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Water level encoding
localparam [1:0]
    BELOW_S0      = 2'd0,
    BETWEEN_S1_S0 = 2'd1,
    BETWEEN_S2_S1 = 2'd2,
    ABOVE_S2      = 2'd3;

reg [2:0] s_reg;          // Registered sensor inputs
reg [1:0] curr_level;
reg [1:0] prev_level;
reg       level_increased;

// Decode water level from registered sensors (exact matches)
function [1:0] decode_level(input [2:0] s_in);
begin
    case (s_in)
        3'b111: decode_level = ABOVE_S2;      // All sensors asserted
        3'b110: decode_level = BETWEEN_S2_S1; // s2=1,s1=1,s0=0 invalid in problem? But only 110 means s2=1,s1=1,s0=0, which is missing in problem states
        3'b100: decode_level = BETWEEN_S1_S0; // s2=1,s1=0,s0=0 (also invalid?)
        3'b011: decode_level = BETWEEN_S1_S0; // s2=0,s1=1,s0=1 (correct between s2,s1)
        3'b010: decode_level = BETWEEN_S1_S0; // s2=0,s1=1,s0=0 (not defined)
        3'b001: decode_level = BETWEEN_S1_S0; // s2=0,s1=0,s0=1
        3'b000: decode_level = BELOW_S0;      // None asserted
        3'b101: decode_level = BETWEEN_S1_S0; // s2=1,s1=0,s0=1 (not defined)
        default: decode_level = BELOW_S0;     // Default to BELOW_S0 for unknown states
    endcase
end
endfunction

// Improved decode_level based on problem definition (strict patterns):
// To strictly follow problem sensor patterns:
// Above s[2] => s = 111
// Between s[2] and s[1] => s = 110 (s[2]=1, s[1]=1, s[0]=0)
// Between s[1] and s[0] => s = 100 (s[2]=1, s[1]=0, s[0]=0) ??? Actually problem states Between s[1] and s[0] corresponds to s = 3'b100? Actually problem states Between s[1] and s[0] means s[0]=1 only asserted, so s=001. So let me redo:

// Let's define a function that exactly matches problem states:
// Above s[2]: s[2]=1,s[1]=1,s[0]=1 => 3'b111
// Between s[2] and s[1]: s[2]=0, s[1]=1, s[0]=1 => 3'b011
// Between s[1] and s[0]: s[2]=0, s[1]=0, s[0]=1 => 3'b001
// Below s[0]: none asserted => 3'b000

// Any other values: map to nearest defined level by priority

function [1:0] decode_level_strict(input [2:0] s_in);
begin
    if (s_in == 3'b111)
        decode_level_strict = ABOVE_S2;
    else if (s_in == 3'b011)
        decode_level_strict = BETWEEN_S2_S1;
    else if (s_in == 3'b001)
        decode_level_strict = BETWEEN_S1_S0;
    else if (s_in == 3'b000)
        decode_level_strict = BELOW_S0;
    else begin
        // Map other states conservatively:
        // If s[2]=1, but not 111, treat as ABOVE_S2 (highest)
        if (s_in[2] == 1'b1)
            decode_level_strict = ABOVE_S2;
        // Else if s[1]=1, treat as BETWEEN_S2_S1
        else if (s_in[1] == 1'b1)
            decode_level_strict = BETWEEN_S2_S1;
        // Else if s[0]=1, treat as BETWEEN_S1_S0
        else if (s_in[0] == 1'b1)
            decode_level_strict = BETWEEN_S1_S0;
        else
            decode_level_strict = BELOW_S0;
    end
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        s_reg       <= 3'b000;
        curr_level  <= BELOW_S0;
        prev_level  <= BELOW_S0;
        level_increased <= 1'b0;
        fr0         <= 1'b1;
        fr1         <= 1'b1;
        fr2         <= 1'b1;
        dfr         <= 1'b1;
    end else begin
        s_reg <= s;
        prev_level <= curr_level;
        curr_level <= decode_level_strict(s_reg);

        // Compare level after updating levels (using previous values)
        // Because non-blocking assignments take effect simultaneously,
        // calculate level_increased from prev_level (old curr_level) and curr_level (new).
        // But cannot do this directly in always block, so compute level_increased from last cycle's values.
        // To do so, use an intermediate reg.

        // Implemented in a separate always block after levels update:
        // But here we'll store the calculation for next cycle output.

        // Outputs assigned after registers updated in another always block below
    end
end

// Separate sequential block to update level_increased and outputs,
// runs after levels updated and uses the updated curr_level and prev_level
always @(posedge clk) begin
    if (reset) begin
        level_increased <= 1'b0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        level_increased <= (curr_level > prev_level);

        // Drive outputs based on curr_level and level_increased
        case (curr_level)
            ABOVE_S2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BETWEEN_S2_S1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BETWEEN_S1_S0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BELOW_S0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            default: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
        endcase
    end
end

endmodule