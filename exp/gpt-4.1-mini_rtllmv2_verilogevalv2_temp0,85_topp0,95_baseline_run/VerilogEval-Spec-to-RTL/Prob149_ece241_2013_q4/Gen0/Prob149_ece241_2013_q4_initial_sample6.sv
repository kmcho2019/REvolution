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
// 2 = between s2 and s1 (s0 and s1 asserted)
// 3 = above s2 (all sensors asserted)

reg [1:0] prev_level;
reg [1:0] curr_level;

// Function to decode sensor inputs to water level encoding
function [1:0] decode_level(input [2:0] sensors);
    begin
        case (sensors)
            3'b000: decode_level = 2'd0; // below s0
            3'b001: decode_level = 2'd1; // between s1 and s0 (s0 only)
            3'b011: decode_level = 2'd2; // between s2 and s1 (s0 and s1)
            3'b111: decode_level = 2'd3; // above s2 (all sensors)
            default: begin
                // For any other pattern, choose closest matching:
                // If s2==1 and s1==1 => level 3 or 2
                // If s2==0 and s1==1 => level 2 or 1
                // If s0==1 only => 1
                // else 0
                if (sensors == 3'b010) decode_level = 2'd2; // s1 only (treat as between s2 and s1)
                else if (sensors == 3'b100) decode_level = 2'd1; // s2 only (treat as between s1 and s0)
                else if (sensors == 3'b101) decode_level = 2'd2; // s2 and s0 (treat as between s2 and s1)
                else if (sensors == 3'b110) decode_level = 2'd3; // s2 and s1 (between s2 and s1)
                else decode_level = 2'd0;
            end
        endcase
    end
endfunction

wire [1:0] new_level = decode_level(s);

wire rising = (new_level > prev_level);
wire falling = (new_level < prev_level);

always @(posedge clk) begin
    if (reset) begin
        // Reset: assume water level low for long time
        prev_level <= 2'd0; // below s0
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        curr_level <= new_level;
        // Update prev_level only on sensor change (rising or falling)
        if (new_level != prev_level) begin
            prev_level <= new_level;
        end

        // Determine nominal flow valves according to current level
        case (new_level)
            2'd3: begin // above s2 - no valves on
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd2: begin // between s2 and s1
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd1: begin // between s1 and s0
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            2'd0: begin // below s0
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

        // dfr (supplemental flow valve) asserted if water level rising compared to previous
        dfr <= rising ? 1'b1 : 1'b0;
    end
end

endmodule