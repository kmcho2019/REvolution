module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding:
    // 0 = below s[0]
    // 1 = between s[0] and s[1]
    // 2 = between s[1] and s[2]
    // 3 = above s[2]

    reg [1:0] prev_level;
    reg [1:0] current_level;

    // Decode sensor input to water level
    always @(*) begin
        // Enforce cumulative sensor hierarchy:
        // If highest sensor s[2] is asserted, level = 3
        // Else if s[1] asserted, level = 2
        // Else if s[0] asserted, level = 1
        // Else level = 0
        if (s[2])
            current_level = 2'd3;
        else if (s[1])
            current_level = 2'd2;
        else if (s[0])
            current_level = 2'd1;
        else
            current_level = 2'd0;
    end

    // Update prev_level each clock cycle to current_level (stable)
    always @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0; // below s[0]
        else
            prev_level <= current_level;
    end

    // Nominal flow outputs
    // level 3 (above s[2]) : all valves closed (0)
    // level 2 : fr0=1, fr1=0, fr2=0
    // level 1 : fr0=1, fr1=1, fr2=0
    // level 0 : fr0=1, fr1=1, fr2=1
    wire fr0_val = (current_level != 2'd3);
    wire fr1_val = (current_level == 2'd0) || (current_level == 2'd1);
    wire fr2_val = (current_level == 2'd0);

    // Supplemental flow valve dfr: asserted if water level rose compared to prev_level
    wire dfr_val = (current_level > prev_level);

    // On reset outputs max flow valves open including supplemental (all 1)
    assign fr0 = reset ? 1'b1 : fr0_val;
    assign fr1 = reset ? 1'b1 : fr1_val;
    assign fr2 = reset ? 1'b1 : fr2_val;
    assign dfr = reset ? 1'b1 : dfr_val;

endmodule