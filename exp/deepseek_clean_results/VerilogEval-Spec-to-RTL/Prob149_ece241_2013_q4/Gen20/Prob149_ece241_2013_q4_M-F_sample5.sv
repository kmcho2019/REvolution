module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State definitions
    reg [1:0] current_state, prev_state;

    // State transition and storage
    always @(posedge clk) begin
        if (reset) begin
            current_state <= 2'b00; // STATE_BELOW
            prev_state <= 2'b00;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_state <= current_state;
            
            // Update current state based on sensors
            case (s)
                3'b111: current_state <= 2'b11; // STATE_ABOVE
                3'b011: current_state <= 2'b10; // STATE_MID_HIGH
                3'b001: current_state <= 2'b01; // STATE_MID_LOW
                3'b000: current_state <= 2'b00; // STATE_BELOW
                default: current_state <= current_state; // maintain state
            endcase
            
            // Update outputs based on current state
            case (current_state)
                2'b11: {fr2, fr1, fr0} <= 3'b000; // Above s[2]
                2'b10: {fr2, fr1, fr0} <= 3'b001; // Between s[2]-s[1]
                2'b01: {fr2, fr1, fr0} <= 3'b011; // Between s[1]-s[0]
                2'b00: {fr2, fr1, fr0} <= 3'b111; // Below s[0]
            endcase
            
            // Set dfr if we're moving to a higher level
            dfr <= (current_state > prev_state);
        end
    end

endmodule