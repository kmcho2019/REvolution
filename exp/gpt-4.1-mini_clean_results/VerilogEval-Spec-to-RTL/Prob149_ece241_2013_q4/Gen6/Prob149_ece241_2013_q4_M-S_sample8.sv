module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding:
    // 3 = Above s[2]
    // 2 = Between s[2] and s[1]
    // 1 = Between s[1] and s[0]
    // 0 = Below s[0]

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    wire [1:0] sensor_level;

    // Decode sensor input into water level (priority from highest sensor)
    assign sensor_level = (s[2]) ? 2'd3 :
                          (s[1]) ? 2'd2 :
                          (s[0]) ? 2'd1 : 2'd0;

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0; // BELOW
            prev_level <= 2'd0; // BELOW
        end else begin
            if (sensor_level != curr_level) begin
                prev_level <= curr_level;
                curr_level <= sensor_level;
            end
        end
    end

    // Nominal flow valve outputs based on current water level
    // Above s[2] (3): none asserted
    // Between s[2] and s[1] (2): fr0 only
    // Between s[1] and s[0] (1): fr0, fr1
    // Below s[0] (0): fr0, fr1, fr2

    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental valve open if water level increased since last sensor change
    wire dfr_nominal = (curr_level > prev_level);

    // During reset, all valves open (asserted)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_nominal;

endmodule