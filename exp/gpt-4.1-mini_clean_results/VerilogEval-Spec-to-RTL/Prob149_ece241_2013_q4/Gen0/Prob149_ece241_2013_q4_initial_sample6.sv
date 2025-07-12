module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define water level regions as local parameters for clarity
    localparam REGION_BELOW   = 2'd0;
    localparam REGION_BETWEEN_1_0 = 2'd1;
    localparam REGION_BETWEEN_2_1 = 2'd2;
    localparam REGION_ABOVE   = 2'd3;

    reg [1:0] prev_region;

    // Function to determine the water level region from sensor inputs
    function [1:0] get_region;
        input [2:0] sensors;
        begin
            if (sensors == 3'b111)
                get_region = REGION_ABOVE;
            else if (sensors[2] == 0 && sensors[1] == 1 && sensors[0] == 1)
                get_region = REGION_BETWEEN_2_1;
            else if (sensors[2] == 0 && sensors[1] == 0 && sensors[0] == 1)
                get_region = REGION_BETWEEN_1_0;
            else // sensors == 0 or any other case treated as below lowest sensor
                get_region = REGION_BELOW;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // On reset: simulate water level below s[0] for a long time
            prev_region <= REGION_BELOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            reg [1:0] curr_region;
            curr_region = get_region(s);

            // Outputs depend on nominal flow rate table
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
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Determine dfr based on water level rising or not
            // rising if curr_region > prev_region
            dfr <= (curr_region > prev_region) ? 1'b1 : 1'b0;

            // Update prev_region for next cycle
            prev_region <= curr_region;
        end
    end

endmodule