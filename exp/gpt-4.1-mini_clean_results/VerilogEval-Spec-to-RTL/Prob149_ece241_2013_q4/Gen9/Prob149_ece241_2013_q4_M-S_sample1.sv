module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level codes for easy comparison and logic:
    // 0 = Below s[0]    (none asserted)
    // 1 = Between s[1] and s[0] (only s[0] asserted)
    // 2 = Between s[2] and s[1] (s[0] and s[1] asserted)
    // 3 = Above s[2]     (s[0], s[1], s[2] asserted)
    //
    // Other sensor states are treated as BELOW_S0 for safety.
    
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    reg [1:0] prev_level;

    // Decode water level from sensors synchronously
    wire [1:0] curr_level = (s == 3'b000) ? BELOW_S0 :
                            (s == 3'b001) ? BETWEEN_S1_S0 :
                            (s == 3'b011) ? BETWEEN_S2_S1 :
                            (s == 3'b111) ? ABOVE_S2 :
                            BELOW_S0; // default safe

    // Update prev_level and dfr at clock
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= BELOW_S0;
            dfr <= 1'b1; // dfr asserted on reset as per spec
        end else begin
            dfr <= (curr_level > prev_level);
            prev_level <= curr_level;
        end
    end

    // Nominal flow rates according to water level:
    // Above s[2]           : no flow (fr0=fr1=fr2=0)
    // Between s[2] and s[1]: fr0 only
    // Between s[1] and s[0]: fr0 and fr1
    // Below s[0]           : fr0, fr1, fr2
    assign fr2 = (curr_level == BELOW_S0);
    assign fr1 = (curr_level == BELOW_S0) || (curr_level == BETWEEN_S1_S0);
    assign fr0 = (curr_level != ABOVE_S2);

endmodule