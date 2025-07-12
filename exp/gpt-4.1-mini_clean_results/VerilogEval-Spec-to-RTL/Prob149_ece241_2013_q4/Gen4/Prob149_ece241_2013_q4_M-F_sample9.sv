module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Function to decode sensor pattern into water level encoding
    // Levels:
    // 0 = below s0 (no sensors asserted)
    // 1 = between s1 and s0 (only s0 asserted)
    // 2 = between s2 and s1 (s0 and s1 asserted)
    // 3 = above s2 (all sensors asserted)
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_level = 2'd0;
                3'b001: decode_level = 2'd1;
                3'b011: decode_level = 2'd2;
                3'b111: decode_level = 2'd3;
                default: decode_level = 2'd0; // conservative default for any unexpected pattern
            endcase
        end
    endfunction

    reg [1:0] curr_level, prev_level;

    // Sequential block to update water levels
    always @(posedge clk) begin
        if (reset) begin
            // Reset to low water level, all valves open
            prev_level <= 2'd0;
            curr_level <= 2'd0;
        end else begin
            // Decode new level from sensors
            wire [1:0] new_level = decode_level(s);
            // Update prev_level only if sensor pattern (and thus level) changes
            if (new_level != curr_level) begin
                prev_level <= curr_level;
                curr_level <= new_level;
            end
        end
    end

    // Nominal flow outputs combinationally from current sensors as per spec
    // Above s2 (all sensors asserted): no flow valves open
    // Between s2 and s1 (s0 and s1 asserted): fr0 only
    // Between s1 and s0 (only s0 asserted): fr0 and fr1
    // Below s0 (no sensors asserted): fr0, fr1, fr2 all open
    // Other sensor combinations conservatively default to all valves open

    wire [2:0] nominal_flows = (s == 3'b111) ? 3'b000 :
                               (s == 3'b011) ? 3'b001 :
                               (s == 3'b001) ? 3'b011 :
                               (s == 3'b000) ? 3'b111 :
                               3'b111;

    assign {fr2, fr1, fr0} = nominal_flows;

    // dfr asserted if current level > previous level (water level rising)
    assign dfr = (curr_level > prev_level) ? 1'b1 : 1'b0;

endmodule