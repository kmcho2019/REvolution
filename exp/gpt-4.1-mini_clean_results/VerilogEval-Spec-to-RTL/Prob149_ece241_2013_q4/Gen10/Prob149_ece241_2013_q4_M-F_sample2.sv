module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level ordinals corresponding to sensor patterns:
    // BELOW (0): no sensors asserted (000)
    // BETWEEN0 (1): s[0] asserted only (100 or others with s[0] but not s[1], s[2])
    // BETWEEN1 (2): s[0], s[1] asserted (110)
    // ABOVE (3): all sensors asserted (111)
    localparam BELOW    = 2'd0;
    localparam BETWEEN0 = 2'd1;
    localparam BETWEEN1 = 2'd2;
    localparam ABOVE    = 2'd3;

    reg [1:0] curr_level, prev_level;

    // Function to map arbitrary sensor input s to one of the defined levels
    // according to problem specification:
    // Priority: If s[2] == 1 => ABOVE
    // else if s[1] == 1 => BETWEEN1
    // else if s[0] == 1 => BETWEEN0
    // else BELOW
    // This covers all inputs by mapping to the closest valid level.
    wire [1:0] next_level = (s[2]) ? ABOVE :
                           (s[1]) ? BETWEEN1 :
                           (s[0]) ? BETWEEN0 :
                                    BELOW;

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            prev_level <= curr_level;
            curr_level <= next_level;
        end
    end

    // Nominal flow valve outputs based on current level
    // ABOVE: none
    // BETWEEN1: fr0
    // BETWEEN0: fr0, fr1
    // BELOW: fr0, fr1, fr2
    wire nominal_fr0 = (curr_level != ABOVE);
    wire nominal_fr1 = (curr_level == BETWEEN0) || (curr_level == BELOW);
    wire nominal_fr2 = (curr_level == BELOW);

    // Supplemental flow valve when water level rising
    // Rising detected when current level ordinal > previous
    wire supplemental_dfr = (curr_level > prev_level);

    // Outputs assert all during reset; else nominal + supplemental
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule