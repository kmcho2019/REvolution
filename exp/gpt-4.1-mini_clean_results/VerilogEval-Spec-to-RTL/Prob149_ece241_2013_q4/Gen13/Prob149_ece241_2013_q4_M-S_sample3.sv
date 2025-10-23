module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // only s[0] asserted
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE_S2      = 2'd3; // all sensors asserted

    // Decode sensor inputs to water level (map only valid patterns)
    // Treat any other pattern as BELOW_S0 for safety.
    wire [1:0] new_level = (s == 3'b111) ? ABOVE_S2 :
                           (s == 3'b011) ? BETWEEN_S2_S1 :
                           (s == 3'b001) ? BETWEEN_S1_S0 :
                           BELOW_S0;

    reg [1:0] stable_level, prev_level;

    always @(posedge clk) begin
        if (reset) begin
            stable_level <= BELOW_S0;
            prev_level   <= BELOW_S0;
            dfr          <= 1'b1;
        end else if (new_level != stable_level) begin
            dfr          <= (new_level > stable_level) ? 1'b1 : 1'b0;
            prev_level   <= stable_level;
            stable_level <= new_level;
        end
        // else retain dfr value
    end

    // Nominal flow outputs combinationally:
    // ABOVE_S2: all valves off
    // BETWEEN_S2_S1: fr0 only
    // BETWEEN_S1_S0: fr0 and fr1
    // BELOW_S0: fr0, fr1, fr2
    assign fr0 = (stable_level != ABOVE_S2);
    assign fr1 = (stable_level == BETWEEN_S1_S0) || (stable_level == BELOW_S0);
    assign fr2 = (stable_level == BELOW_S0);

endmodule