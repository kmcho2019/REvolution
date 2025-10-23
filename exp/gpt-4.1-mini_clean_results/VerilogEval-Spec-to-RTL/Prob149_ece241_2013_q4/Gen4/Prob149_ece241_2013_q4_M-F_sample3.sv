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

    reg [2:0] prev_s;    // sensor state after last confirmed change
    reg [2:0] next_s;    // pending new sensor state after sensor change detected
    reg [1:0] prev_level; // level before last sensor change
    reg       update_next_s; // flag indicating that next_s is valid and waiting update

    wire sensor_change = (s != prev_s);
    wire [1:0] curr_level = decode_level(s);

    // At clock edge, manage prev_level and prev_s updates
    always @(posedge clk) begin
        if (reset) begin
            prev_s        <= 3'b000;  // lowest level (no sensors asserted)
            prev_level    <= 2'd0;    // level below s[0]
            next_s        <= 3'b000;
            update_next_s <= 1'b0;
        end else begin
            if (sensor_change && !update_next_s) begin
                // Sensor change detected and no pending update
                // Latch current prev_s into prev_level before updating prev_s
                prev_level    <= decode_level(prev_s);
                next_s        <= s;       // hold new sensor state pending update
                update_next_s <= 1'b1;   // indicate next_s is pending
            end else if (update_next_s) begin
                // Now update prev_s to next_s (new sensor state)
                prev_s        <= next_s;
                update_next_s <= 1'b0;   // done updating
                // prev_level unchanged (holds level before sensor change)
            end else begin
                // No sensor change, no pending update, hold values
                prev_level    <= prev_level;
                prev_s        <= prev_s;
                next_s        <= next_s;
                update_next_s <= update_next_s;
            end
        end
    end

    // Nominal flow valves depend only on current level:
    // Level 3 (above s[2]): none asserted
    // Level 2 (between s[2] and s[1]): fr0
    // Level 1 (between s[1] and s[0]): fr0, fr1
    // Level 0 (below s[0]): fr0, fr1, fr2
    wire fr0_nominal = (curr_level <= 2'd2);
    wire fr1_nominal = (curr_level <= 2'd1);
    wire fr2_nominal = (curr_level == 2'd0);

    // Supplemental valve asserted if water level rose since previous level
    wire dfr_int = (curr_level > prev_level);

    // Outputs with synchronous reset forcing all valves open (asserted)
    assign fr0 = reset ? 1'b1 : fr0_nominal;
    assign fr1 = reset ? 1'b1 : fr1_nominal;
    assign fr2 = reset ? 1'b1 : fr2_nominal;
    assign dfr = reset ? 1'b1 : dfr_int;

endmodule