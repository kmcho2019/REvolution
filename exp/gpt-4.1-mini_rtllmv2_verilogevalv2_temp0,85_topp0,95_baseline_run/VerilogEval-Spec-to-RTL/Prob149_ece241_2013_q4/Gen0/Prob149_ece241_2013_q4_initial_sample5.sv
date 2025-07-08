module TopModule (
    input wire clk,
    input wire reset,
    input wire [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Function to convert sensor input to water level index
    // level: 3 = above s[2], 2 = between s[2] and s[1], 1 = between s[1] and s[0], 0 = below s[0]
    // others treated as 3 (above s[2])
    function [1:0] sensor_to_level;
        input [2:0] sens;
        begin
            case (sens)
                3'b111: sensor_to_level = 2'd3; // above s[2]
                3'b110: sensor_to_level = 2'd2; // between s[2] and s[1]
                3'b100: sensor_to_level = 2'd1; // between s[1] and s[0]
                3'b000: sensor_to_level = 2'd0; // below s[0]
                default: sensor_to_level = 2'd3; // treat other cases as above s[2]
            endcase
        end
    endfunction

    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, assume water level below s[0] long time:
            // fr0, fr1, fr2, dfr all asserted
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
            prev_level <= 2'd0;
        end else begin
            // Determine current water level
            reg [1:0] curr_level;
            curr_level = sensor_to_level(s);

            // Determine nominal flow outputs based on current level
            case (curr_level)
                2'd3: begin
                    // above s[2], no flow outputs
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin
                    // between s[2] and s[1], fr0 only
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin
                    // between s[1] and s[0], fr0 and fr1
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin
                    // below s[0], fr0, fr1, fr2
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // safety default, treat as above s[2]
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
            endcase

            // Determine dfr: supplemental valve open if level rose since last
            // level change
            if (curr_level > prev_level) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end

            // Update prev_level on sensor change
            if (s != sensor_to_level(prev_level)) begin
                prev_level <= curr_level;
            end else begin
                // keep prev_level same if no sensor change
                prev_level <= prev_level;
            end
        end
    end

endmodule