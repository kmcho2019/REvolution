module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output reg    fr2,
    output reg    fr1,
    output reg    fr0,
    output reg    dfr
);

    // Water level: 0 to 3 = number of consecutive asserted sensors from bottom
    reg [1:0] curr_level, prev_level;

    // Function to compute water level as number of consecutive asserted sensors from bottom
    // For example: s=3'b111 -> 3, s=3'b011 -> 2, s=3'b001 -> 1, s=3'b000 -> 0
    // If sensors are non-consecutive asserted, level is max consecutive from bottom only
    function [1:0] calc_level;
        input [2:0] sensors;
        begin
            if (sensors[0] == 1'b0) begin
                // bottom sensor not asserted => level 0
                calc_level = 2'd0;
            end else if (sensors[1] == 1'b0) begin
                // only s[0] asserted
                calc_level = 2'd1;
            end else if (sensors[2] == 1'b0) begin
                // s[0] and s[1] asserted
                calc_level = 2'd2;
            end else begin
                // all three asserted
                calc_level = 2'd3;
            end
        end
    endfunction

    wire [1:0] next_level = calc_level(s);

    wire level_rising = (next_level > curr_level);

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset:
            // Level at 0 (below s[0]) as if low water long time
            // All flows and dfr asserted
            curr_level <= 2'd0;
            prev_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update levels
            if (next_level != curr_level) begin
                prev_level <= curr_level;
                curr_level <= next_level;
            end else begin
                // no level change
                curr_level <= curr_level;
                prev_level <= prev_level;
            end

            // Nominal flow rate outputs based on curr_level
            // Level 3: above s[2]: fr0=0, fr1=0, fr2=0
            // Level 2: between s[2] and s[1]: fr0=1, fr1=0, fr2=0
            // Level 1: between s[1] and s[0]: fr0=1, fr1=1, fr2=0
            // Level 0: below s[0]: fr0=1, fr1=1, fr2=1
            case (curr_level)
                2'd3: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Defensive default all flows open
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve dfr asserted when water level rises
            // i.e., current level > previous level
            dfr <= level_rising ? 1'b1 : 1'b0;
        end
    end

endmodule