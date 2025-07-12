module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Count how many sensors are asserted (0..3)
    wire [1:0] curr_level_count;
    assign curr_level_count = s[0] + s[1] + s[2]; // sums as integer

    // Register to hold previous water level count
    reg [1:0] prev_level_count;

    // Detect rising water level (current level > previous level)
    wire rising_level;
    assign rising_level = (curr_level_count > prev_level_count);

    // Sequential logic to store previous sensor level and dfr pulse
    always @(posedge clk) begin
        if (reset) begin
            prev_level_count <= 2'd0; // no sensors asserted = below s0
            dfr <= 1'b1;              // supplemental valve open on reset
        end else begin
            prev_level_count <= curr_level_count;
            dfr <= rising_level ? 1'b1 : 1'b0;
        end
    end

    // Assign flow valves combinationally based on current water level count
    always @(*) begin
        case (curr_level_count)
            3'd3: begin // Above s[2] (all sensors asserted)
                fr0 = 1'b0;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            3'd2: begin // Between s[2] and s[1]
                fr0 = 1'b1;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            3'd1: begin // Between s[1] and s[0]
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b0;
            end
            default: begin // 0 sensors asserted - Below s[0]
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
        endcase
    end

endmodule