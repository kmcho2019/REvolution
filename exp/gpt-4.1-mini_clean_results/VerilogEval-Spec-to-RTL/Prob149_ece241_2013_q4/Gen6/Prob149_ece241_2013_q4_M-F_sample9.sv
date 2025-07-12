module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Enumerated water level definition
    // 0 = below s[0]      (no sensors asserted)
    // 1 = between s[1] and s[0] (only s[0] asserted)
    // 2 = between s[2] and s[1] (only s[0] and s[1] asserted)
    // 3 = above s[2]      (all sensors asserted)

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    // Decode water level from sensor pattern
    always @(*) begin
        case (s)
            3'b111: curr_level = 2'd3; // above s[2]
            3'b011: curr_level = 2'd2; // between s[2] and s[1]
            3'b001: curr_level = 2'd1; // between s[1] and s[0]
            3'b000: curr_level = 2'd0; // below s[0]
            default: begin
                // For other sensor patterns (e.g. 3'b010, 3'b100, 3'b101, 3'b110)
                // Conservative approach: assign lowest level to maximize flow
                // This avoids unsafe flow reductions.
                curr_level = 2'd0;
            end
        endcase
    end

    // On reset, initialize prev_level to below s[0], outputs asserted high
    // On rising edge, update prev_level and generate dfr pulse if level rises
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update dfr if water level rising compared to previous
            dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;
            prev_level <= curr_level;

            // Assign flow valves based on current water level
            case (curr_level)
                2'd3: begin // above s[2] - all valves closed
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin // between s[2] and s[1]
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin // between s[1] and s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin // below s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Defensive fallback, should not occur
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase
        end
    end

endmodule