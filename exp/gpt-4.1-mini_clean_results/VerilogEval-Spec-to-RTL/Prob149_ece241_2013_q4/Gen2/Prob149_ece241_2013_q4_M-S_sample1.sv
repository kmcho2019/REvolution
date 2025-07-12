module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encode water level based on sensor inputs:
    // 0: no sensors asserted (below s0)
    // 1: only s0 asserted (between s1 and s0)
    // 2: s0 and s1 asserted (between s2 and s1)
    // 3: all sensors asserted (above s2)
    function [1:0] get_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: get_level = 2'd0;
                3'b001: get_level = 2'd1;
                3'b011: get_level = 2'd2;
                3'b111: get_level = 2'd3;
                default: get_level = 2'd0; // conservative default for other patterns
            endcase
        end
    endfunction

    reg [1:0] curr_level, prev_level;
    reg [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
            curr_level <= 2'd0;
            prev_s <= 3'b000;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update prev_level only if sensors changed
            if (s != prev_s) begin
                prev_level <= curr_level;
                prev_s <= s;
                curr_level <= get_level(s);
            end else begin
                // No sensor change, keep levels
                curr_level <= curr_level;
                prev_level <= prev_level;
                prev_s <= prev_s;
            end

            // Assign nominal flows according to current sensors
            case (s)
                3'b111: begin fr0 <= 1'b0; fr1 <= 1'b0; fr2 <= 1'b0; end // above s2
                3'b011: begin fr0 <= 1'b1; fr1 <= 1'b0; fr2 <= 1'b0; end // between s2 and s1
                3'b001: begin fr0 <= 1'b1; fr1 <= 1'b1; fr2 <= 1'b0; end // between s1 and s0
                3'b000: begin fr0 <= 1'b1; fr1 <= 1'b1; fr2 <= 1'b1; end // below s0
                default: begin fr0 <= 1'b1; fr1 <= 1'b1; fr2 <= 1'b1; end // conservative default
            endcase

            // dfr is asserted if water level increased since previous stable level
            dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule