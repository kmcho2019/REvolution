module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level ordinal definitions:
    // BELOW (0): no sensors asserted (000)
    // BETWEEN0 (1): s[0] asserted only (others with s[0] but not s[1], s[2])
    // BETWEEN1 (2): s[0] and s[1] asserted (110)
    // ABOVE (3): all sensors asserted (111)
    localparam BELOW    = 2'd0;
    localparam BETWEEN0 = 2'd1;
    localparam BETWEEN1 = 2'd2;
    localparam ABOVE    = 2'd3;

    reg [1:0] curr_level, prev_level;

    // Map sensor input to level ordinal per priority
    wire [1:0] next_level = (s[2]) ? ABOVE :
                           (s[1]) ? BETWEEN1 :
                           (s[0]) ? BETWEEN0 :
                                    BELOW;

    // Track if water level changed this cycle
    wire level_changed = (next_level != curr_level);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to BELOW level with all valves open (per spec)
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            if (level_changed) begin
                // On sensor level change: update prev_level to old curr_level
                prev_level <= curr_level;
                curr_level <= next_level;
            end else begin
                // No level change: keep prev_level unchanged, update curr_level to reflect current input
                curr_level <= next_level;
                // prev_level stays the same
            end
        end
    end

    // Nominal flow valve outputs based on current level
    // ABOVE: none asserted
    // BETWEEN1: fr0 asserted only
    // BETWEEN0: fr0 and fr1 asserted
    // BELOW: fr0, fr1, fr2 asserted
    wire nominal_fr0 = (curr_level != ABOVE);
    wire nominal_fr1 = (curr_level == BETWEEN0) || (curr_level == BELOW);
    wire nominal_fr2 = (curr_level == BELOW);

    // Supplemental flow valve (dfr) asserted when water level is rising
    // Rising means: level_changed && (curr_level > prev_level)
    wire supplemental_dfr = level_changed && (curr_level > prev_level);

    // Outputs assert all during reset, else nominal + supplemental
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule