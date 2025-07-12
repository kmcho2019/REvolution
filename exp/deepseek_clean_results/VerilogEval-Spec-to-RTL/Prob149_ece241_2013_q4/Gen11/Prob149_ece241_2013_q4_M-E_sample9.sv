module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // FSM states
    typedef enum logic [1:0] {
        STATE_ABOVE_ALL,  // Above s[2]
        STATE_MID_HIGH,   // Between s[2] and s[1]
        STATE_MID_LOW,    // Between s[1] and s[0]
        STATE_BELOW_ALL   // Below s[0]
    } state_t;

    state_t current_state, next_state;
    reg [2:0] prev_sensors;
    wire rising_water;

    // Detect rising water when any sensor goes from 0->1
    assign rising_water = (s[0] & ~prev_sensors[0]) |
                         (s[1] & ~prev_sensors[1]) |
                         (s[2] & ~prev_sensors[2]);

    // State transition logic
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_ABOVE_ALL;
            3'b011:  next_state = STATE_MID_HIGH;
            3'b001:  next_state = STATE_MID_LOW;
            3'b000:  next_state = STATE_BELOW_ALL;
            default: next_state = current_state; // Hold state for invalid patterns
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_ALL;
            prev_sensors <= 3'b000;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_sensors <= s;
            current_state <= next_state;

            // Nominal flow outputs based on state
            case (current_state)
                STATE_ABOVE_ALL: {fr2, fr1, fr0} <= 3'b000;
                STATE_MID_HIGH: {fr2, fr1, fr0} <= 3'b001;
                STATE_MID_LOW:  {fr2, fr1, fr0} <= 3'b011;
                STATE_BELOW_ALL: {fr2, fr1, fr0} <= 3'b111;
                default:         {fr2, fr1, fr0} <= 3'b000;
            endcase

            // Supplemental flow when rising or below all
            dfr <= rising_water || (current_state == STATE_BELOW_ALL);
        end
    end

endmodule