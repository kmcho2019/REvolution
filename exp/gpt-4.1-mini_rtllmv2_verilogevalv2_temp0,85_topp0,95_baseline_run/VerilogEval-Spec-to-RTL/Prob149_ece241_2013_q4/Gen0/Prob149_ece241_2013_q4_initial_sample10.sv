module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encode water level based on sensors s
    // 3 = Above s[2] (all sensors asserted)
    // 2 = Between s[2] and s[1] (s[0] and s[1] asserted only)
    // 1 = Between s[1] and s[0] (s[0] asserted only)
    // 0 = Below s[0] (no sensors asserted)
    function [1:0] get_level;
        input [2:0] s_in;
        begin
            case (s_in)
                3'b111: get_level = 2'd3; // Above s[2]
                3'b011: get_level = 2'd2; // Between s[2] and s[1]
                3'b001: get_level = 2'd1; // Between s[1] and s[0]
                default: get_level = 2'd0; // Below s[0]
            endcase
        end
    endfunction

    reg [1:0] prev_level, curr_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to "Below s[0]" state: no sensors asserted,
            // all outputs asserted (fr0, fr1, fr2, dfr)
            prev_level <= 2'd0;
            curr_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            curr_level <= get_level(s);

            // Determine nominal flow rate outputs based on current_level
            case (curr_level)
                2'd3: begin // Above s[2]
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin // Between s[2] and s[1]
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin // Between s[1] and s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin // Below s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
            endcase

            // Supplemental valve dfr is enabled if water level is rising
            // i.e., current_level > prev_level
            if (curr_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;

            prev_level <= curr_level;
        end
    end

endmodule