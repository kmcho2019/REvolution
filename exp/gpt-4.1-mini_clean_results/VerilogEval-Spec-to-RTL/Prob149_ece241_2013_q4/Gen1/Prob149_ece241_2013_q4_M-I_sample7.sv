module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level regions as localparams
    localparam REGION_BELOW        = 2'd0;
    localparam REGION_BETWEEN_1_0 = 2'd1;
    localparam REGION_BETWEEN_2_1 = 2'd2;
    localparam REGION_ABOVE        = 2'd3;

    reg [1:0] prev_region;

    // Function to determine region based on sensor inputs robustly
    function [1:0] get_region;
        input [2:0] sensors;
        integer count;
        begin
            // Count number of asserted sensors (from bottom to top)
            count = sensors[0] + sensors[1] + sensors[2];

            case (count)
                3: get_region = REGION_ABOVE;        // All sensors asserted
                2: get_region = REGION_BETWEEN_2_1;  // Between s[2] and s[1]
                1: get_region = REGION_BETWEEN_1_0;  // Between s[1] and s[0]
                default: get_region = REGION_BELOW;  // 0 or any other
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset: simulate water level below s[0], all flow valves open
            prev_region <= REGION_BELOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            reg [1:0] curr_region;
            curr_region = get_region(s);

            // Set outputs based on nominal flow rate table
            case (curr_region)
                REGION_ABOVE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                REGION_BETWEEN_2_1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                REGION_BETWEEN_1_0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                REGION_BELOW: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Defensive default, treat as below
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // dfr asserted if water level rising (current region > previous region)
            dfr <= (curr_region > prev_region) ? 1'b1 : 1'b0;

            // Update prev_region for next cycle
            prev_region <= curr_region;
        end
    end

endmodule