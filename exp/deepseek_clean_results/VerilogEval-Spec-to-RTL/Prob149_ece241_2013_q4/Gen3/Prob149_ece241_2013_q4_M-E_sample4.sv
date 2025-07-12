module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define states for water level positions
    typedef enum {
        ABOVE,      // Above s[2]
        MID_HIGH,   // Between s[2] and s[1]
        MID_LOW,    // Between s[1] and s[0]
        BELOW       // Below s[0]
    } state_t;

    state_t current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        case (s)
            3'b111:  next_state = ABOVE;
            3'b011:  next_state = MID_HIGH;
            3'b001:  next_state = MID_LOW;
            3'b000:  next_state = BELOW;
            default: next_state = current_state; // Handle invalid sensor patterns
        endcase
    end

    // State register and transition detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state <= BELOW;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Output generation
    always @(*) begin
        // Default outputs
        {fr2, fr1, fr0, dfr} = 4'b0000;

        case (current_state)
            ABOVE:    {fr2, fr1, fr0} = 3'b000;
            MID_HIGH: {fr2, fr1, fr0} = 3'b001;
            MID_LOW:  {fr2, fr1, fr0} = 3'b011;
            BELOW:    {fr2, fr1, fr0} = 3'b111;
        endcase

        // Set dfr if water level is rising (current > previous)
        dfr = (current_state < prev_state) ? 1'b1 : 1'b0;

        // Override outputs during reset
        if (reset) {fr2, fr1, fr0, dfr} = 4'b1111;
    end

endmodule