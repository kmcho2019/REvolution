module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level states encoded as 2 bits
    // 0: BELOW (no sensors)
    // 1: BETWEEN s[1] and s[0] (only s[0] asserted)
    // 2: BETWEEN s[2] and s[1] (s[0] and s[1] asserted)
    // 3: ABOVE (all sensors asserted)
    localparam BELOW    = 2'd0;
    localparam BETWEEN0 = 2'd1;
    localparam BETWEEN1 = 2'd2;
    localparam ABOVE    = 2'd3;

    reg [1:0] curr_level, prev_level;

    // Determine next water level state by exact sensor patterns
    wire [1:0] next_level = (s == 3'b111) ? ABOVE :
                           (s == 3'b110) ? BETWEEN1 :
                           (s == 3'b100) ? BETWEEN0 :
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
    wire supplemental_dfr = (curr_level > prev_level);

    // Outputs assert all during reset; else nominal + supplemental
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule