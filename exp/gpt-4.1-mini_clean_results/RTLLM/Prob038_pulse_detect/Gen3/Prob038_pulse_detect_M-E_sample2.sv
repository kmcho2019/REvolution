module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE          = 2'b00, // Waiting for data_in == 0
        WAIT_FOR_HIGH = 2'b01, // After 0 detected, waiting for data_in == 1
        WAIT_FOR_LOW  = 2'b10  // After 1 detected, waiting for data_in == 0 to complete pulse
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        // Default next state is current state
        next_state = state;
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH; // Got initial 0, expect 1 next
                else
                    next_state = IDLE;           // Stay in IDLE if data_in==1
            end

            WAIT_FOR_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_LOW;  // Got the 1 in pulse, wait for last 0
                else if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH; // Still 0, keep waiting for 1
                else
                    next_state = IDLE;           // Reset fallback (though data_in is 1 bit)
            end

            WAIT_FOR_LOW: begin
                if (data_in == 1'b0)
                    next_state = IDLE;           // Pulse complete, go back to IDLE
                else if (data_in == 1'b1)
                    next_state = WAIT_FOR_LOW;  // Still 1, waiting for 0
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output and state update logic (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out asserted only for one cycle at the last 0 of pulse
            data_out <= (state == WAIT_FOR_LOW && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

endmodule