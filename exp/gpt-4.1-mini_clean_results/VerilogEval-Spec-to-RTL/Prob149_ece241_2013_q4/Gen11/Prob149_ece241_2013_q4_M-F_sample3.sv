module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level states (ordinal encoding)
    localparam BELOW    = 2'd0;  // no sensors asserted (000)
    localparam BETWEEN0 = 2'd1;  // only s[0] asserted (100)
    localparam BETWEEN1 = 2'd2;  // s[0] and s[1] asserted (110)
    localparam ABOVE    = 2'd3;  // all sensors asserted (111)

    // Decode current water level from sensors with explicit patterns; others treated as BELOW
    wire [1:0] curr_level = (s == 3'b111) ? ABOVE :
                           (s == 3'b110) ? BETWEEN1 :
                           (s == 3'b100) ? BETWEEN0 :
                           (s == 3'b000) ? BELOW :
                           BELOW;  // any other pattern treated as BELOW

    // Register to hold previous water level state
    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset)
            prev_level <= BELOW;  // On reset, assume low water level
        else
            prev_level <= curr_level;
    end

    // Nominal flow rate outputs based on current water level
    // Above s[2] (ABOVE): no nominal valves open (fr0=0, fr1=0, fr2=0)
    // Between s[2] and s[1] (BETWEEN1): fr0 only
    // Between s[1] and s[0] (BETWEEN0): fr0 and fr1
    // Below s[0] (BELOW): fr0, fr1, and fr2
    wire nominal_fr0 = (curr_level != ABOVE);
    wire nominal_fr1 = (curr_level == BETWEEN0) || (curr_level == BELOW);
    wire nominal_fr2 = (curr_level == BELOW);

    // Supplemental flow valve open if water level is rising (current level > previous level)
    wire supplemental_dfr = (curr_level > prev_level);

    // Outputs: on reset, assert all valves (simulate low water level long time)
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule