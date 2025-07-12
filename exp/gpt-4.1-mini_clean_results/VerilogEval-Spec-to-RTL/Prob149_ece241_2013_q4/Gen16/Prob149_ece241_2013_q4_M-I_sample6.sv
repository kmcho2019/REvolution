module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding (2 bits)
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // s[0] only
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1]
    localparam ABOVE_S2      = 2'd3; // s[0], s[1], s[2]

    // Decode sensor inputs into water levels directly (combinational)
    wire above_s2      = s[2];
    wire between_s2_s1 = (s[2] == 0) && s[1] && s[0];
    wire between_s1_s0 = (s[2] == 0) && (s[1] == 0) && s[0];

    wire [1:0] new_level =
        above_s2      ? ABOVE_S2      :
        between_s2_s1 ? BETWEEN_S2_S1 :
        between_s1_s0 ? BETWEEN_S1_S0 :
                       BELOW_S0;

    reg [1:0] stable_level;
    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to lowest water level, all valves open including dfr
            stable_level <= BELOW_S0;
            prev_level   <= BELOW_S0;
            dfr          <= 1'b1;
        end else if (new_level != stable_level) begin
            // Capture old stable level before update
            // Update dfr according to whether new_level > old stable_level (prev_level)
            dfr          <= (new_level > stable_level);
            prev_level   <= stable_level;
            stable_level <= new_level;
        end
        // else no change, dfr holds its value
    end

    // Nominal flow outputs depend on stable_level:
    // ABOVE_S2: no valves open
    // BETWEEN_S2_S1: fr0 only
    // BETWEEN_S1_S0: fr0 and fr1
    // BELOW_S0: fr0, fr1, fr2
    assign fr0 = (stable_level != ABOVE_S2);
    assign fr1 = (stable_level == BETWEEN_S1_S0) || (stable_level == BELOW_S0);
    assign fr2 = (stable_level == BELOW_S0);

endmodule