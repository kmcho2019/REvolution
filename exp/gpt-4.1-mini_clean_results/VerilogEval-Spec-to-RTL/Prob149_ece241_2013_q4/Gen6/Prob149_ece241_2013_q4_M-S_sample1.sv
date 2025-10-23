module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water levels as parameters for clarity
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    reg [1:0] curr_level, prev_level;
    reg [2:0] prev_s;

    // Decode water level from sensors per problem spec
    // s = {s2, s1, s0}
    // Above s2: s[2]=1,s[1]=1,s[0]=1 -> 3'b111
    // Between s2 and s1: s[2]=0,s[1]=1,s[0]=1 -> 3'b011
    // Between s1 and s0: s[2]=0,s[1]=0,s[0]=1 -> 3'b001
    // Below s0: s[2]=0,s[1]=0,s[0]=0 -> 3'b000
    // Other patterns not defined - treat as below s0 for safety.

    wire [1:0] decoded_level = 
        (s == 3'b111) ? ABOVE_S2 :
        (s == 3'b011) ? BETWEEN_S2_S1 :
        (s == 3'b001) ? BETWEEN_S1_S0 :
        (s == 3'b000) ? BELOW_S0 :
        BELOW_S0;

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW_S0;
            prev_level <= BELOW_S0;
            prev_s <= 3'b000;
            dfr <= 1'b1; // Supplemental flow valve ON at reset
        end else begin
            // Detect sensor change
            if (s != prev_s) begin
                prev_level <= curr_level;
                curr_level <= decoded_level;
                prev_s <= s;
                // dfr asserted if current level is higher than previous
                dfr <= (decoded_level > curr_level) ? 1'b1 : 1'b0;
            end else begin
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow outputs combinational from current level
    assign fr2 = (curr_level == BELOW_S0);
    assign fr1 = (curr_level == BELOW_S0) || (curr_level == BETWEEN_S1_S0);
    assign fr0 = (curr_level != ABOVE_S2);

endmodule