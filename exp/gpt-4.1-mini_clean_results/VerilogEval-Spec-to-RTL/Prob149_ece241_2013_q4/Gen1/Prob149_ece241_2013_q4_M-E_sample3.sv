module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define water level encoding:
    // 0 = below s0 (no sensors asserted)
    // 1 = between s1 and s0 (only s0 asserted)
    // 2 = between s2 and s1 (s1 and s0 asserted)
    // 3 = above s2 (all sensors asserted)
    // Others map to closest lower or to 0 conservatively

    function [1:0] sensor_to_level;
        input [2:0] sensor;
        begin
            case (sensor)
                3'b000: sensor_to_level = 2'd0; // below s0
                3'b001: sensor_to_level = 2'd1; // between s1 and s0
                3'b011: sensor_to_level = 2'd2; // between s2 and s1
                3'b111: sensor_to_level = 2'd3; // above s2
                default: sensor_to_level = 2'd0; // conservative default
            endcase
        end
    endfunction

    reg [1:0] prev_level;
    reg [1:0] curr_level;
    reg [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, start at lowest water level with all valves open
            prev_level <= 2'd0;
            curr_level <= 2'd0;
            prev_s <= 3'b000;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Determine current water level from sensors
            curr_level <= sensor_to_level(s);

            // On sensor change, update prev_level to old curr_level before update
            if (s != prev_s) begin
                prev_level <= curr_level;
                prev_s <= s;
            end

            // Assign nominal flows per current sensors
            // According to problem table:
            // Above s2 (3'b111): fr0=0, fr1=0, fr2=0
            // Between s2 and s1 (3'b011): fr0=1, fr1=0, fr2=0
            // Between s1 and s0 (3'b001): fr0=1, fr1=1, fr2=0
            // Below s0 (3'b000): fr0=1, fr1=1, fr2=1
            // Default: same as below s0

            case (s)
                3'b111: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                3'b011: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                3'b001: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                3'b000: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // dfr is asserted if water level increased compared to prev_level (previous level before last sensor change)
            // This means current level > prev_level
            if (curr_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule