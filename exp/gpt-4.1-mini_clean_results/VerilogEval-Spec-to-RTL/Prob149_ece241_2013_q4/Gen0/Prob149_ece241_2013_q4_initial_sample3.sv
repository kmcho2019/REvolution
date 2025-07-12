module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define water level as integer for comparison
    // Map s pattern to water level:
    // 3'b111 => 3 (above s2)
    // 3'b011 => 2 (between s2 and s1)
    // 3'b001 => 1 (between s1 and s0)
    // 3'b000 => 0 (below s0)
    // other values treated as closest lower level (safe to treat as 0)
    function [1:0] water_level;
        input [2:0] sensor;
        begin
            case (sensor)
                3'b111: water_level = 2'd3;
                3'b011: water_level = 2'd2;
                3'b001: water_level = 2'd1;
                3'b000: water_level = 2'd0;
                default: water_level = 2'd0;
            endcase
        end
    endfunction

    reg [2:0] prev_s;
    reg [1:0] prev_level;

    reg [1:0] curr_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset state:
            // previous level low (0), outputs all 1 (max flow and supplemental)
            prev_s <= 3'b000;
            prev_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            curr_level = water_level(s);

            // Update nominal flow valves based on current s level
            case (s)
                3'b111: begin // above s2
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                3'b011: begin // between s2 and s1
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                3'b001: begin // between s1 and s0
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                3'b000: begin // below s0
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin // For any other combination, treat as below s0 (conservative)
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Determine supplemental flow valve (dfr)
            // If sensor changed and water level increased compared to previous, open dfr
            if (s != prev_s && (curr_level > prev_level))
                dfr <= 1'b1;
            else
                dfr <= 1'b0;

            // Update previous state
            prev_s <= s;
            prev_level <= curr_level;
        end
    end

endmodule