module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Water level zones
    localparam ZONE_HIGH  = 2'd3;  // All sensors on (above s[2])
    localparam ZONE_MID   = 2'd2;  // s[1] and s[0] on
    localparam ZONE_LOW   = 2'd1;  // Only s[0] on
    localparam ZONE_BELOW = 2'd0;  // No sensors on

    reg [1:0] current_zone, prev_zone;

    // Priority encoder for current zone
    wire [1:0] zone_encoded;
    assign zone_encoded = s[2] ? ZONE_HIGH :
                         s[1] ? ZONE_MID :
                         s[0] ? ZONE_LOW :
                         ZONE_BELOW;

    // Zone history tracking
    always @(posedge clk) begin
        if (reset) begin
            current_zone <= ZONE_BELOW;
            prev_zone <= ZONE_BELOW;
        end else begin
            prev_zone <= current_zone;
            current_zone <= zone_encoded;
        end
    end

    // Detect if water level was previously lower
    wire was_lower = (prev_zone < current_zone);

    // Output generation
    assign fr0 = reset ? 1'b1 : (current_zone != ZONE_HIGH);
    assign fr1 = reset ? 1'b1 : (current_zone == ZONE_BELOW || current_zone == ZONE_LOW);
    assign fr2 = reset ? 1'b1 : (current_zone == ZONE_BELOW);
    assign dfr = reset ? 1'b1 : was_lower;

endmodule