module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding (2-bit):
    // 3: above s[2]         (s = 3'b111)
    // 2: between s[2] & s[1]
    // 1: between s[1] & s[0]
    // 0: below s[0]

    // Decode water level from 3-bit sensor input
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = 2'd3; // above s[2]
                3'b011: decode_level = 2'd2; // between s[2] and s[1]
                3'b001: decode_level = 2'd1; // between s[1] and s[0]
                3'b000: decode_level = 2'd0; // below s[0]
                // For other patterns, assign closest lower level:
                3'b010: decode_level = 2'd1; // treat as between s[1] and s[0]
                3'b110: decode_level = 2'd2; // treat as between s[2] and s[1]
                3'b100: decode_level = 2'd1; // treat as between s[1] and s[0]
                3'b101: decode_level = 2'd2; // treat as between s[2] and s[1]
                default: decode_level = 2'd0; // fallback below s[0]
            endcase
        end
    endfunction

    reg [1:0] curr_level, prev_level;

    // Synchronous update of water level registers
    always @(posedge clk) begin
        if (reset) begin
            // On reset: assume water level below lowest sensor (0),
            // and all flow valves asserted
            curr_level <= 2'd0;
            prev_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_level <= curr_level;
            curr_level <= decode_level(s);

            // Determine if water level is rising compared to previous
            dfr <= (decode_level(s) > curr_level) ? 1'b1 : 1'b0;

            // Nominal flow valves based on curr_level:
            // Above s[2] (3): no nominal valves asserted
            // Between s[2] and s[1] (2): fr0 only
            // Between s[1] and s[0] (1): fr0 and fr1
            // Below s[0] (0): fr0, fr1, fr2
            case (decode_level(s))
                2'd3: begin // above s[2]
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
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase
        end
    end

endmodule