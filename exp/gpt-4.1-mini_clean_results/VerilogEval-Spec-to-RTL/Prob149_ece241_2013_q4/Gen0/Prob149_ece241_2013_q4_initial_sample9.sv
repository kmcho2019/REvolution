module TopModule (
    input         clk,
    input         reset,
    input  [2:0]  s,
    output reg    fr2,
    output reg    fr1,
    output reg    fr0,
    output reg    dfr
);

// Register to hold previous sensor state at last change
reg [2:0] prev_s;
reg [2:0] curr_s;

// Helper function to count sensors asserted (from s[0] lowest to s[2] highest)
function integer sensor_level;
    input [2:0] sensors;
    begin
        // sensor_level encodes water level by number of sensors asserted:
        // no sensors: 0, s[0] only:1, s[0]&s[1]:2, s[0]&s[1]&s[2]:3
        // But since sensors are asserted bottom-up, we can use a code:
        // We'll assign levels as below:
        // 3'b000 => 0 (below lowest)
        // 3'b001 => 1 (between s0 and s1)
        // 3'b011 => 2 (between s1 and s2)
        // 3'b111 => 3 (above s2)
        // Other patterns invalid, treat them as closest lower level.
        // Check sensors from highest to lowest

        if (sensors == 3'b111)
            sensor_level = 3; // above s2
        else if (sensors[2] == 1'b0 && sensors[1] == 1'b1 && sensors[0] == 1'b1)
            sensor_level = 2; // between s2 and s1: s[0], s[1]
        else if (sensors[2] == 1'b0 && sensors[1] == 1'b0 && sensors[0] == 1'b1)
            sensor_level = 1; // between s1 and s0: s[0]
        else if (sensors == 3'b000)
            sensor_level = 0; // below s0
        else begin
            // For other invalid patterns, find closest lower level
            if (sensors[0] == 1'b0)
                sensor_level = 0;
            else if (sensors[1] == 1'b0)
                sensor_level = 1;
            else if (sensors[2] == 1'b0)
                sensor_level = 2;
            else
                sensor_level = 3;
        end
    end
endfunction

// Determine nominal flow based on sensor input
// returns 3-bit {fr2, fr1, fr0}
function [2:0] nominal_flow;
    input [2:0] sensors;
    begin
        case (sensor_level(sensors))
            3: nominal_flow = 3'b000; // above s2 no flow
            2: nominal_flow = 3'b001; // fr0 only
            1: nominal_flow = 3'b011; // fr0, fr1
            0: nominal_flow = 3'b111; // fr0, fr1, fr2
            default: nominal_flow = 3'b000;
        endcase
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset to below lowest sensor and maximum flow
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update prev_s on sensor change
        if (s != prev_s) begin
            prev_s <= s;
        end
        
        // Calculate current flow outputs
        // Nominal flow according to current sensors
        {fr2, fr1, fr0} <= nominal_flow(s);
        
        // Supplemental flow dfr is asserted if water level rose:
        // i.e. sensor_level(s) > sensor_level(prev_s)
        if (sensor_level(s) > sensor_level(prev_s))
            dfr <= 1'b1;
        else
            dfr <= 1'b0;
    end
end

endmodule