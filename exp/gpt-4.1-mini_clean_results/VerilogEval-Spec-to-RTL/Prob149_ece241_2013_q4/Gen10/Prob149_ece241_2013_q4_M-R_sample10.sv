module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding (2 bits)
    localparam BELOW    = 2'd0;  // no sensors asserted (000) or others not matching known patterns
    localparam BETWEEN0 = 2'd1;  // only s[0] asserted (100)
    localparam BETWEEN1 = 2'd2;  // s[0] and s[1] asserted (110)
    localparam ABOVE    = 2'd3;  // all sensors asserted (111)

    // Combinational decode of current water level from sensors
    wire [1:0] curr_level = (s == 3'b111) ? ABOVE :
                           (s == 3'b110) ? BETWEEN1 :
                           (s == 3'b100) ? BETWEEN0 :
                           BELOW;

    // Registered previous water level state to detect rising transitions
    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset)
            prev_level <= BELOW; // Initialize to BELOW on reset
        else
            prev_level <= curr_level;
    end

    // Nominal flow outputs based on current level
    // ABOVE: no nominal valves open
    // BETWEEN1: fr0 only
    // BETWEEN0: fr0 and fr1
    // BELOW: fr0, fr1, fr2
    wire nominal_fr0 = (curr_level != ABOVE);
    wire nominal_fr1 = (curr_level == BETWEEN0) || (curr_level == BELOW);
    wire nominal_fr2 = (curr_level == BELOW);

    // Supplemental valve dfr asserted if water level rising (curr_level > prev_level)
    wire supplemental_dfr = (curr_level > prev_level);

    // Output assignments with synchronous reset asserting all outputs (simulate long low level)
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule