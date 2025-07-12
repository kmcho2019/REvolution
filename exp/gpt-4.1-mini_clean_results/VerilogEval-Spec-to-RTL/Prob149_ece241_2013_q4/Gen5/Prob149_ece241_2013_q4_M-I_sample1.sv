module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Enumerated water levels:
    // 3 = above s[2]
    // 2 = between s[2] and s[1]
    // 1 = between s[1] and s[0]
    // 0 = below s[0]
    typedef enum reg [1:0] {
        BELOW    = 2'd0,
        BTWN_10  = 2'd1,
        BTWN_21  = 2'd2,
        ABOVE    = 2'd3
    } water_level_t;

    // Decode level based on sensor bits:
    // Priority: s[2] > s[1] > s[0]
    // This accounts for any possible input patterns robustly.
    function water_level_t decode_level(input [2:0] sensors);
        begin
            if (sensors[2])
                decode_level = ABOVE;
            else if (sensors[1])
                decode_level = BTWN_21;
            else if (sensors[0])
                decode_level = BTWN_10;
            else
                decode_level = BELOW;
        end
    endfunction

    reg [1:0] curr_level, prev_level;

    wire [1:0] sensor_level = decode_level(s);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to lowest level with all valves asserted
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            if (sensor_level != curr_level) begin
                prev_level <= curr_level;
                curr_level <= sensor_level;
            end
            // else no change
        end
    end

    // Nominal valve outputs based on current water level
    // Level 3 (above s[2]): none asserted
    // Level 2 (between s[2] and s[1]): fr0 only
    // Level 1 (between s[1] and s[0]): fr0 and fr1
    // Level 0 (below s[0]): fr0, fr1, fr2
    wire fr0_nominal = (curr_level <= BTWN_21);
    wire fr1_nominal = (curr_level <= BTWN_10);
    wire fr2_nominal = (curr_level == BELOW);

    // Supplemental valve dfr asserted if current level > previous level
    wire dfr_int = (curr_level > prev_level);

    // Outputs with synchronous reset forcing all valves open (asserted)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule