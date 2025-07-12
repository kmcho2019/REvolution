module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Zone definitions (continuous, not state-based)
    wire in_zone_above_s2   = &s;       // All sensors on
    wire in_zone_between_s2_s1 = (s[1:0] == 2'b11); // s[0] and s[1] on
    wire in_zone_between_s1_s0 = (s[0] & ~s[1]);    // Only s[0] on
    wire in_zone_below_s0  = ~|s;       // No sensors on

    // Previous sensor values for transition detection
    reg [2:0] prev_s;
    always @(posedge clk) begin
        if (reset)
            prev_s <= 3'b000; // Start as if coming from below
        else
            prev_s <= s;
    end

    // Determine if we're coming from a lower level (for dfr)
    wire coming_from_lower = 
        (in_zone_above_s2   && (prev_s == 3'b011)) ||  // Came from between s2-s1
        (in_zone_between_s2_s1 && (prev_s == 3'b001)) || // Came from between s1-s0
        (in_zone_between_s1_s0 && (prev_s == 3'b000));   // Came from below s0

    // Current zone priority encoder (highest zone takes precedence)
    reg [1:0] current_zone;
    always @(*) begin
        if (in_zone_above_s2)
            current_zone = 2'b00;
        else if (in_zone_between_s2_s1)
            current_zone = 2'b01;
        else if (in_zone_between_s1_s0)
            current_zone = 2'b10;
        else
            current_zone = 2'b11; // below_s0
    end

    // Output generation
    assign fr0 = (current_zone >= 2'b01); // Zones 1,2,3
    assign fr1 = (current_zone >= 2'b10); // Zones 2,3
    assign fr2 = (current_zone == 2'b11); // Zone 3 only
    assign dfr = coming_from_lower;

endmodule