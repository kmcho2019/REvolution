module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define levels:
    // 3 = Above s[2] (highest)
    // 2 = Between s[2] and s[1]
    // 1 = Between s[1] and s[0]
    // 0 = Below s[0]
    reg [1:0] prev_level, curr_level;

    // Function to decode sensor input into level
    function [1:0] sensor_to_level;
        input [2:0] s_in;
        begin
            if (s_in[2] == 1'b1)
                sensor_to_level = 2'd3;
            else if (s_in[1] == 1'b1)
                sensor_to_level = 2'd2;
            else if (s_in[0] == 1'b1)
                sensor_to_level = 2'd1;
            else
                sensor_to_level = 2'd0;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to lowest water level and all valves open
            prev_level <= 2'd0;
            curr_level <= 2'd0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else begin
            curr_level <= sensor_to_level(s);
            
            // Outputs based on current level
            case (curr_level)
                2'd3: begin // Above s[2]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                2'd2: begin // Between s[2] and s[1]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                2'd1: begin // Between s[1] and s[0]
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                2'd0: begin // Below s[0]
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                default: begin // Should not happen, treat as lowest level
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
            endcase

            // Determine if water level rose compared to prev_level
            if (curr_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;

            // Update prev_level only when level changes
            if (curr_level != prev_level)
                prev_level <= curr_level;
        end
    end

endmodule