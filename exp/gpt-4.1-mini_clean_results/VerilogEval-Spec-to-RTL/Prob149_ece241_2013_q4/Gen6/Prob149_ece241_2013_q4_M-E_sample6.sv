module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Register to hold previous sensor input
    reg [2:0] prev_s;

    // Compute numeric water level from sensor input:
    // level 3 if s[2] == 1 (above s2)
    // else level 2 if s[1] == 1 (between s2 and s1)
    // else level 1 if s[0] == 1 (between s1 and s0)
    // else level 0 (below s0)
    function [1:0] level_from_sensors(input [2:0] sensors);
        begin
            if (sensors[2])
                level_from_sensors = 2'd3;
            else if (sensors[1])
                level_from_sensors = 2'd2;
            else if (sensors[0])
                level_from_sensors = 2'd1;
            else
                level_from_sensors = 2'd0;
        end
    endfunction

    wire [1:0] curr_level = level_from_sensors(s);
    wire [1:0] prev_level = level_from_sensors(prev_s);

    // On reset, set prev_s = 0 (no sensors asserted)
    // Else store current sensors for next cycle comparison
    always @(posedge clk) begin
        if (reset)
            prev_s <= 3'b000;
        else
            prev_s <= s;
    end

    // Nominal valves logic per current water level
    // Level 3 (above s2): none asserted
    // Level 2 (between s2 and s1): fr0 only
    // Level 1 (between s1 and s0): fr0, fr1
    // Level 0 (below s0): fr0, fr1, fr2

    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental flow valve dfr asserted if water level increased
    wire dfr_int = (curr_level > prev_level);

    // During reset, assert all valves (open)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule