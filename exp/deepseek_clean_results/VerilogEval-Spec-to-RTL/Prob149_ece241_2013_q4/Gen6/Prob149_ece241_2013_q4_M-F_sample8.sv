module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;
    reg [1:0] prev_level, curr_level;

    // Function to determine water level based on highest activated sensor
    function [1:0] get_level;
        input [2:0] sensors;
        begin
            if (sensors[2])       get_level = 2'd3;  // Above s[2]
            else if (sensors[1]) get_level = 2'd2;  // Between s[2] and s[1]
            else if (sensors[0]) get_level = 2'd1;  // Between s[1] and s[0]
            else                 get_level = 2'd0;  // Below s[0]
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to maximum flow (all outputs high)
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_s <= 3'b000;
            prev_level <= 2'd0;
        end else begin
            // Store previous sensor state and level
            prev_s <= s;
            prev_level <= curr_level;
            
            // Determine current water level
            curr_level <= get_level(s);

            // Nominal flow outputs (unchanged from working version)
            fr0 <= ~s[2];                     // fr0 on unless above s[2]
            fr1 <= ~(s[2] | s[1]);            // fr1 on when below s[1]
            fr2 <= ~(s[2] | s[1] | s[0]);     // fr2 on when below s[0]

            // Supplemental flow (dfr) when level was previously lower
            dfr <= (curr_level > prev_level);
        end
    end

endmodule