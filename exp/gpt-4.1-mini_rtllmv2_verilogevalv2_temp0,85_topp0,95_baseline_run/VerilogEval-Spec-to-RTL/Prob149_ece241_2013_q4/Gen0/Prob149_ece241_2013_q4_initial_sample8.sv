module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Level encoding:
// 3 = Above s[2]     (s == 3'b111)
// 2 = Between s[2] & s[1] (s == 3'b110 or close)
// 1 = Between s[1] & s[0] (s == 3'b001 or close)
// 0 = Below s[0]     (s == 3'b000)

reg [1:0] curr_level, prev_level;

function [1:0] sensor_to_level;
    input [2:0] s_in;
    begin
        case (s_in)
            3'b111: sensor_to_level = 2'd3; // Above s[2]
            3'b110: sensor_to_level = 2'd2; // Between s[2] and s[1]
            3'b101: sensor_to_level = 2'd2; // treat as Between s[2] and s[1]
            3'b100: sensor_to_level = 2'd1; // Between s[1] and s[0]
            3'b011: sensor_to_level = 2'd2; // treat as Between s[2] and s[1]
            3'b010: sensor_to_level = 2'd1; // Between s[1] and s[0]
            3'b001: sensor_to_level = 2'd1; // Between s[1] and s[0]
            3'b000: sensor_to_level = 2'd0; // Below s[0]
            default: sensor_to_level = 2'd0; // default to lowest level for safety
        endcase
    end
endfunction

// Sequential logic to track current and previous level
always @(posedge clk) begin
    if (reset) begin
        // Reset to lowest level (Below s[0]) and all flow outputs asserted
        curr_level <= 2'd0;
        prev_level <= 2'd0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b0; // supplemental valve off (no rising condition)
    end else begin
        prev_level <= curr_level;
        curr_level <= sensor_to_level(s);

        // Determine nominal flow outputs and dfr
        // nominal flow depends on curr_level
        // supplemental flow dfr enabled if water rising (prev_level < curr_level)

        dfr <= (prev_level < curr_level) ? 1'b1 : 1'b0;

        case (curr_level)
            2'd3: begin // Above s[2]
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd2: begin // Between s[2] and s[1]
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd1: begin // Between s[1] and s[0]
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            2'd0: begin // Below s[0]
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                // Should not happen, default to safe max flow
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule