module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding - ordered by water level
    localparam BELOW  = 2'b00; // No sensors
    localparam MID    = 2'b01; // Only s[0]
    localparam HIGH   = 2'b10; // s[1] and s[0]
    localparam ABOVE  = 2'b11; // All sensors

    reg [1:0] state, next_state;
    reg [1:0] prev_state;
    reg water_rising;

    // State transition logic - explicitly handle all valid sensor patterns
    always @(*) begin
        case (s)
            3'b000: next_state = BELOW;  // Below s[0]
            3'b001: next_state = MID;    // Only s[0] (between s[1]-s[0])
            3'b011: next_state = HIGH;  // s[1] & s[0] (between s[2]-s[1])
            3'b111: next_state = ABOVE; // All sensors (above s[2])
            default: next_state = BELOW; // Invalid patterns -> assume lowest level
        endcase
    end

    // State and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= BELOW;
            prev_state <= BELOW;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Update state history first
            prev_state <= state;
            state <= next_state;

            // Calculate if water is rising (previous state was lower)
            water_rising <= (prev_state < state);

            // Output logic
            fr0 <= (state != ABOVE);
            fr1 <= (state == BELOW) || (state == MID);
            fr2 <= (state == BELOW);
            dfr <= water_rising;
        end
    end

endmodule