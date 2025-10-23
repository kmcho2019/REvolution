module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Enumerate levels for clarity
localparam LEVEL_BELOW   = 2'd0; // no sensors asserted
localparam LEVEL_BETWEEN1 = 2'd1; // s[0] asserted only
localparam LEVEL_BETWEEN2 = 2'd2; // s[0] and s[1] asserted
localparam LEVEL_ABOVE    = 2'd3; // s[0], s[1], s[2] asserted

// Function to determine water level from sensor input
function [1:0] get_level(input [2:0] s_in);
    begin
        if (s_in == 3'b111)
            get_level = LEVEL_ABOVE;
        else if (s_in[0] && s_in[1] && !s_in[2])
            get_level = LEVEL_BETWEEN2;
        else if (s_in[0] && !s_in[1] && !s_in[2])
            get_level = LEVEL_BETWEEN1;
        else if (s_in == 3'b000)
            get_level = LEVEL_BELOW;
        else begin
            // Handle ambiguous or illegal states conservatively:
            // If sensors in an undefined pattern, treat as highest level not asserted but lower ones maybe.
            // For safety, assign level based on how many sensors asserted starting from s[0].
            // Count how many sensors asserted from s[0] upwards, assign level accordingly.
            // This is a fallback, the problem does not specify intermediate invalid states explicitly.
            // We'll prioritize the highest number of sensors asserted starting from s[0].
            if (s_in[0]) begin
                if (s_in[1]) begin
                    if (s_in[2]) get_level = LEVEL_ABOVE; else get_level = LEVEL_BETWEEN2;
                end else get_level = LEVEL_BETWEEN1;
            end else get_level = LEVEL_BELOW;
        end
    end
endfunction

reg [1:0] prev_level;

always @(posedge clk) begin
    if (reset) begin
        // Reset to "Below s[0]" with all outputs asserted
        prev_level <= LEVEL_BELOW;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine current level
        reg [1:0] curr_level;
        curr_level = get_level(s);

        // Determine if water level is rising compared to prev_level
        // Rising = curr_level > prev_level
        reg rising;
        rising = (curr_level > prev_level);

        // Update prev_level
        prev_level <= curr_level;

        // Drive nominal flow valves based on current level:
        case (curr_level)
            LEVEL_ABOVE: begin
                // no nominal flow valves on
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            LEVEL_BETWEEN2: begin
                // fr0 on
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            LEVEL_BETWEEN1: begin
                // fr0, fr1 on
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            LEVEL_BELOW: begin
                // fr0, fr1, fr2 on
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                // Safety: turn off all valves
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
        endcase

        // dfr (supplemental valve) is opened if water level rising, else off
        dfr <= rising ? 1'b1 : 1'b0;
    end
end

endmodule