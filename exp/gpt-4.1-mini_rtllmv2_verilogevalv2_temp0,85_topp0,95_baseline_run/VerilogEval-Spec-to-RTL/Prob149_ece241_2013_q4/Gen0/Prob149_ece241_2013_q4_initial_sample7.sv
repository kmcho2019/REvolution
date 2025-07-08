module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    reg [2:0] prev_s;

    // Function to determine the water level index:
    // 0: below s[0] (no sensors asserted)
    // 1: between s[0] and s[1] (s == 3'b100)
    // 2: between s[1] and s[2] (s == 3'b110)
    // 3: above s[2] (s == 3'b111)
    // Anything else treated as below s[0]
    function [1:0] level_from_s;
        input [2:0] ss;
        begin
            case (ss)
                3'b000: level_from_s = 2'd0; // below s[0]
                3'b100: level_from_s = 2'd1; // between s[0] and s[1]
                3'b110: level_from_s = 2'd2; // between s[1] and s[2]
                3'b111: level_from_s = 2'd3; // above s[2]
                default: level_from_s = 2'd0; // treat others as below s[0]
            endcase
        end
    endfunction

    wire [1:0] curr_level = level_from_s(s);
    reg  [1:0] prev_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to low water level with all flow valves open
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
            prev_level <= 2'd0;
        end else begin
            // Update outputs based on current sensor state
            case (curr_level)
                2'd3: begin // Above s[2]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0; // no supplemental valve
                end
                2'd2: begin // Between s[2] and s[1]
                    // Nominal flow fr0 only
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= (prev_level < curr_level) ? 1'b1 : 1'b0;
                end
                2'd1: begin // Between s[1] and s[0]
                    // Nominal flow fr0 and fr1
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= (prev_level < curr_level) ? 1'b1 : 1'b0;
                end
                2'd0: begin // Below s[0]
                    // All nominal flow valves open
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1; // from reset condition also matches this
                end
                default: begin
                    // Should never happen, but safe default below s[0]
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            endcase

            prev_s <= s;
            prev_level <= curr_level;
        end
    end

endmodule