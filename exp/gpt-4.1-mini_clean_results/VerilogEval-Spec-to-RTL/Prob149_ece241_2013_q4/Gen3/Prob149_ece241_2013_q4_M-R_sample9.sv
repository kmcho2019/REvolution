module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Function to decode water level from sensor input pattern
    // Returns 2-bit level: 3 = above s[2], 2 = between s[2] and s[1], 
    // 1 = between s[1] and s[0], 0 = below s[0]
    // Other patterns are treated as level 0 for safety
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = 2'd3;
                3'b011: decode_level = 2'd2;
                3'b001: decode_level = 2'd1;
                3'b000: decode_level = 2'd0;
                default: decode_level = 2'd0;
            endcase
        end
    endfunction

    // Stored previous sensor inputs and previous water level (decoded from prev_s)
    reg [2:0] prev_s;
    reg [1:0] prev_level;

    wire [1:0] curr_level = decode_level(s);
    wire [1:0] old_level = decode_level(prev_s);

    // Sensor change detection
    wire sensor_change = (s != prev_s);

    always @(posedge clk) begin
        if (reset) begin
            // On reset, set previous sensors to all deasserted (lowest level)
            // and previous level to 0 (below s[0])
            prev_s     <= 3'b000;
            prev_level <= 2'd0;
        end else begin
            if (sensor_change) begin
                // On sensor change, save previous level decoded from prev_s
                prev_level <= old_level;
                // Update stored sensors to current sensors
                prev_s     <= s;
            end else begin
                // No sensor change: hold previous values
                prev_level <= prev_level;
                prev_s     <= prev_s;
            end
        end
    end

    // Nominal flow valves depend only on current level
    // According to spec:
    // Level 3 (above s[2]): none asserted
    // Level 2 (between s[2] and s[1]): fr0
    // Level 1 (between s[1] and s[0]): fr0, fr1
    // Level 0 (below s[0]): fr0, fr1, fr2
    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental valve asserted if water level has risen since previous level before last sensor change
    wire dfr_int = (curr_level > prev_level);

    // Outputs with synchronous reset forcing all valves open (asserted)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule