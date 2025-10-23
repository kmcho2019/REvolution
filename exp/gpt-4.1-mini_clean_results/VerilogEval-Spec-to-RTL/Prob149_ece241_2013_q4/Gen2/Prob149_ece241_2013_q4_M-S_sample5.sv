module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [1:0] curr_level, prev_level;
    reg [2:0] prev_s;

    // Map sensors to water levels:
    // 0: below s0 (no sensors)
    // 1: between s1 and s0 (only s0)
    // 2: between s2 and s1 (s0 and s1)
    // 3: above s2 (all three)
    // Default to 0 if unmatched

    function [1:0] get_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: get_level = 2'd0;
                3'b001: get_level = 2'd1;
                3'b011: get_level = 2'd2;
                3'b111: get_level = 2'd3;
                default: get_level = 2'd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0;
            prev_level <= 2'd0;
            prev_s <= 3'b000;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update prev_level only on sensor changes
            if (s != prev_s) begin
                prev_level <= curr_level;
                prev_s <= s;
            end

            // Update current level
            curr_level <= get_level(s);

            // Set nominal flow valves per curr_level
            case (curr_level)
                2'd3: begin // Above s2: no flows
                    fr0 <= 0;
                    fr1 <= 0;
                    fr2 <= 0;
                end
                2'd2: begin // Between s2 and s1
                    fr0 <= 1;
                    fr1 <= 0;
                    fr2 <= 0;
                end
                2'd1: begin // Between s1 and s0
                    fr0 <= 1;
                    fr1 <= 1;
                    fr2 <= 0;
                end
                2'd0: begin // Below s0
                    fr0 <= 1;
                    fr1 <= 1;
                    fr2 <= 1;
                end
                default: begin
                    fr0 <= 1;
                    fr1 <= 1;
                    fr2 <= 1;
                end
            endcase

            // Supplemental valve: assert if current level > previous level
            dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule