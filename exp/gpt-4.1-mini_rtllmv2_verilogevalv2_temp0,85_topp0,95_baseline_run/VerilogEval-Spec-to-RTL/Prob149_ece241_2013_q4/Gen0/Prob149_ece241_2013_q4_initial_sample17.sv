module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Level encoding
    // 0 = below s[0] (no sensors asserted)
    // 1 = between s[1] and s[0] (s=100)
    // 2 = between s[2] and s[1] (s=110)
    // 3 = above s[2] (s=111)
    reg [1:0] previous_level, current_level;

    // Decode water level from sensors s
    function [1:0] decode_level(input [2:0] s_in);
        begin
            case (s_in)
                3'b111: decode_level = 2'd3; // above s[2]
                3'b110: decode_level = 2'd2; // between s[2] and s[1]
                3'b100: decode_level = 2'd1; // between s[1] and s[0]
                3'b000: decode_level = 2'd0; // below s[0]
                default: decode_level = 2'd0; // treat unknown patterns as below s[0]
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            previous_level <= 2'd0; // assume water level low for a long time
            // All outputs asserted on reset
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            current_level <= decode_level(s);

            // Determine dfr based on level change
            // dfr = 1 if current_level > previous_level (rising)
            dfr <= (current_level > previous_level) ? 1'b1 : 1'b0;

            // Set fr outputs based on current_level
            case (current_level)
                2'd3: begin
                    // above s[2], flow rate zero
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                2'd2: begin
                    // between s[2] and s[1]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                2'd1: begin
                    // between s[1] and s[0]
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                2'd0: begin
                    // below s[0]
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                default: begin
                    // default safe case: all off
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
            endcase

            // Update previous_level for next cycle
            previous_level <= current_level;
        end
    end

endmodule