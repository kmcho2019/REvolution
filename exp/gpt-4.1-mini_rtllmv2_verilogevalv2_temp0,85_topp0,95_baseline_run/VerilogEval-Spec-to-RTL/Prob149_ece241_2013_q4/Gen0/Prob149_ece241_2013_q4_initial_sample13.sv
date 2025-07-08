module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define level encoding:
// 3 = above s[2] (s=111)
// 2 = between s[2] and s[1] (s=110)
// 1 = between s[1] and s[0] (s=100)
// 0 = below s[0] (s=000)
// For other s values, map to closest level logically.

// Function to decode sensor to level
function [1:0] sensor_to_level;
    input [2:0] sensors;
    begin
        case(sensors)
            3'b111: sensor_to_level = 2'd3; // above s[2]
            3'b110: sensor_to_level = 2'd2; // between s[2] and s[1]
            3'b100: sensor_to_level = 2'd1; // between s[1] and s[0]
            3'b000: sensor_to_level = 2'd0; // below s[0]
            default:
                // Map undefined combinations to the closest lower level:
                // If s[0]=1 and s[1]=0 and s[2]=0 => level 1 (between s[1] and s[0])
                // If s[0]=1 and s[1]=1 and s[2]=0 => level 2 (between s[2] and s[1])
                // If s[0]=0 and s[1]=0 and s[2]=1 => treat as above s[2] (3)
                // Else default to 0 (lowest)
                if (sensors[0] && !sensors[1] && !sensors[2])
                    sensor_to_level = 2'd1;
                else if (sensors[0] && sensors[1] && !sensors[2])
                    sensor_to_level = 2'd2;
                else if (!sensors[0] && !sensors[1] && sensors[2])
                    sensor_to_level = 2'd3;
                else
                    sensor_to_level = 2'd0;
        endcase
    end
endfunction

reg [1:0] current_level;
reg [1:0] previous_level;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state representing water level below s[0] for long time:
        // no sensors asserted (s=000)
        // outputs fr0, fr1, fr2, dfr all asserted
        previous_level <= 2'd0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        current_level <= sensor_to_level(s);

        // Update outputs based on current_level
        case(current_level)
            2'd3: begin // above s[2] (s=111)
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd2: begin // between s[2] and s[1] (s=110)
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd1: begin // between s[1] and s[0] (s=100)
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            2'd0: begin // below s[0] (s=000)
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

        // Determine if the previous level was lower than current level
        if (current_level > previous_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;

        // Store current level as previous for next cycle
        previous_level <= current_level;
    end
end

endmodule