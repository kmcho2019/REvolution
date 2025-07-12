module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    reg [1:0] curr_level, prev_level;
    reg [2:0] prev_s;

    // Level encoding:
    // 3: Above s2   (all sensors asserted: s == 3'b111)
    // 2: Between s2 and s1 (s[2]==0, s[1]==1, s[0]==1 -> 3'b011)
    // 1: Between s1 and s0 (only s[0]==1, so s == 3'b001)
    // 0: Below s0   (no sensors asserted: 3'b000)
    // For any other sensor pattern, infer water level by priority:
    // Check s[2], then s[1], then s[0], else 0.

    function [1:0] get_level;
        input [2:0] sensors;
        begin
            if (sensors == 3'b111)           get_level = 2'd3; // Above s2
            else if (sensors == 3'b011)      get_level = 2'd2; // Between s2 and s1
            else if (sensors == 3'b001)      get_level = 2'd1; // Between s1 and s0
            else if (sensors == 3'b000)      get_level = 2'd0; // Below s0
            else begin
                // For other patterns, infer level by checking sensors top-down
                if (sensors[2])               get_level = 2'd3;
                else if (sensors[1])          get_level = 2'd2;
                else if (sensors[0])          get_level = 2'd1;
                else                         get_level = 2'd0;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to lowest water level with all flow valves and dfr asserted
            curr_level <= 2'd0;
            prev_level <= 2'd0;
            prev_s <= 3'b000;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // On any sensor change, update prev_level with curr_level and prev_s
            if (s != prev_s) begin
                prev_level <= curr_level;
                prev_s <= s;
                curr_level <= get_level(s);
            end else begin
                // No sensor change, just keep curr_level stable
                curr_level <= curr_level;
            end

            // Output nominal flow valves based on current water level
            case (curr_level)
                2'd3: begin // Above s2: no flow valves on
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin // Between s2 and s1: fr0 only
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin // Between s1 and s0: fr0 and fr1
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin // Below s0: fr0, fr1, fr2 all on
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

            // Supplemental valve on if water level rising (curr_level > prev_level)
            dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule