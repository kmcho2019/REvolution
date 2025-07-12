module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level zones (numerically higher means physically lower)
    localparam ZONE_ABOVE_ALL = 2'd0;  // Above s[2] (s[2:0] = 111)
    localparam ZONE_MID_HIGH  = 2'd1;  // Between s[2] and s[1] (s[2:0] = 011)
    localparam ZONE_MID_LOW   = 2'd2;  // Between s[1] and s[0] (s[2:0] = 001)
    localparam ZONE_BELOW_ALL = 2'd3;  // Below s[0] (s[2:0] = 000)

    reg [1:0] current_zone;
    reg [1:0] prev_zone;

    // Priority encoder for current zone
    always @(*) begin
        casez (s)
            3'b111: current_zone = ZONE_ABOVE_ALL;
            3'b011: current_zone = ZONE_MID_HIGH;
            3'b001: current_zone = ZONE_MID_LOW;
            3'b000: current_zone = ZONE_BELOW_ALL;
            default: current_zone = prev_zone; // Handle undefined cases
        endcase
    end

    // Sequential logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            prev_zone <= ZONE_BELOW_ALL;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_zone <= current_zone;

            // Nominal flow outputs
            case (current_zone)
                ZONE_ABOVE_ALL: {fr2, fr1, fr0} = 3'b000;
                ZONE_MID_HIGH:  {fr2, fr1, fr0} = 3'b001;
                ZONE_MID_LOW:   {fr2, fr1, fr0} = 3'b011;
                ZONE_BELOW_ALL: {fr2, fr1, fr0} = 3'b111;
                default:        {fr2, fr1, fr0} = 3'b000;
            endcase

            // Supplemental flow output
            dfr <= (current_zone < prev_zone) || (current_zone == ZONE_BELOW_ALL);
        end
    end

endmodule