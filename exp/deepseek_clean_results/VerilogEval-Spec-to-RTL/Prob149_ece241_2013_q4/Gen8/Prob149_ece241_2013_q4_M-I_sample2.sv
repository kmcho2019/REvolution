module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level states with explicit encoding
    localparam BELOW_S0 = 2'b00;  // No sensors
    localparam S0_S1    = 2'b01;  // Only s[0]
    localparam S1_S2    = 2'b10;  // s[1] and s[0]
    localparam ABOVE_S2 = 2'b11;  // All sensors

    reg [1:0] current_level, prev_level;

    // Complete level detection covering all possible sensor combinations
    wire [1:0] next_level = (~s[2] & ~s[1] & ~s[0]) ? BELOW_S0 :  // 000
                            (~s[2] & ~s[1] &  s[0]) ? S0_S1    :  // 001
                            (~s[2] &  s[1] & ~s[0]) ? S0_S1    :  // 010 (invalid but handle as S0_S1)
                            (~s[2] &  s[1] &  s[0]) ? S1_S2    :  // 011
                            ( s[2] & ~s[1] & ~s[0]) ? S1_S2    :  // 100 (invalid but handle as S1_S2)
                            ( s[2] & ~s[1] &  s[0]) ? S1_S2    :  // 101 (invalid but handle as S1_S2)
                            ( s[2] &  s[1] & ~s[0]) ? ABOVE_S2 :  // 110 (invalid but handle as ABOVE_S2)
                            ABOVE_S2;                             // 111

    always @(posedge clk) begin
        if (reset) begin
            // Reset to all outputs high (below s0 condition)
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            current_level <= BELOW_S0;
            prev_level <= BELOW_S0;
        end else begin
            // Update level history
            prev_level <= current_level;
            current_level <= next_level;

            // Nominal flow outputs (combinational function of current level)
            fr0 <= (next_level != ABOVE_S2);
            fr1 <= (next_level == BELOW_S0) || (next_level == S0_S1);
            fr2 <= (next_level == BELOW_S0);

            // Supplemental flow - only when moving to a strictly higher level
            dfr <= (prev_level < current_level) && (current_level != prev_level);
        end
    end

endmodule