module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Water level zones (numerically higher means physically lower)
    localparam ZONE_ABOVE_ALL = 2'd0;  // Above s[2] (s[2:0] = 111)
    localparam ZONE_MID_HIGH  = 2'd1;  // Between s[2] and s[1] (s[2:0] = 011)
    localparam ZONE_MID_LOW   = 2'd2;  // Between s[1] and s[0] (s[2:0] = 001)
    localparam ZONE_BELOW_ALL = 2'd3;  // Below s[0] (s[2:0] = 000)

    reg [1:0] prev_zone;
    wire [1:0] current_zone;

    // Current zone detection
    assign current_zone = (s == 3'b111) ? ZONE_ABOVE_ALL :
                         (s == 3'b011) ? ZONE_MID_HIGH :
                         (s == 3'b001) ? ZONE_MID_LOW :
                         ZONE_BELOW_ALL;

    // Transition detection
    wire water_rising = (current_zone > prev_zone);

    // Nominal flow outputs
    assign fr0 = (current_zone == ZONE_MID_HIGH) || 
                (current_zone == ZONE_MID_LOW) || 
                (current_zone == ZONE_BELOW_ALL);
    assign fr1 = (current_zone == ZONE_MID_LOW) || 
                (current_zone == ZONE_BELOW_ALL);
    assign fr2 = (current_zone == ZONE_BELOW_ALL);

    // Supplemental flow output
    assign dfr = water_rising || (current_zone == ZONE_BELOW_ALL);

    // Sequential logic for previous zone and reset
    always @(posedge clk) begin
        if (reset) begin
            prev_zone <= ZONE_BELOW_ALL;
        end else begin
            prev_zone <= current_zone;
        end
    end

endmodule