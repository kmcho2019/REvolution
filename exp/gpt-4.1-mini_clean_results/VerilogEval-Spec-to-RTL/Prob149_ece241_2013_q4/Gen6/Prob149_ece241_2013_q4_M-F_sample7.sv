module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Decode water level from sensors based on highest asserted sensor
    // Level codes:
    // 3 = above s[2] (s[2] asserted)
    // 2 = between s[2] and s[1] (s[2] not asserted, s[1] asserted)
    // 1 = between s[1] and s[0] (s[2] and s[1] not asserted, s[0] asserted)
    // 0 = below s[0] (no sensors asserted)
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            if (sensors[2]) begin
                decode_level = 2'd3;
            end else if (sensors[1]) begin
                decode_level = 2'd2;
            end else if (sensors[0]) begin
                decode_level = 2'd1;
            end else begin
                decode_level = 2'd0;
            end
        end
    endfunction

    reg [2:0] prev_s;      // previous sensor pattern
    reg [1:0] prev_level;  // water level before last sensor change

    wire [1:0] curr_level = decode_level(s);
    wire sensor_change = (s != prev_s);

    always @(posedge clk) begin
        if (reset) begin
            // Initialize to lowest water level and all valves open
            prev_s     <= 3'b000;
            prev_level <= 2'd0;
        end else if (sensor_change) begin
            // Update prev_level with level of previous sensor reading
            prev_level <= decode_level(prev_s);
            prev_s     <= s;
        end
        // else keep prev_s and prev_level unchanged
    end

    // Nominal flow valves according to current level:
    // Level 3: none open (all 0)
    // Level 2: fr0 only
    // Level 1: fr0 and fr1
    // Level 0: fr0, fr1, fr2
    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental valve open if water level has risen since last sensor change
    wire dfr_nominal = (curr_level > prev_level);

    // On reset outputs all valves open (asserted)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_nominal;

endmodule