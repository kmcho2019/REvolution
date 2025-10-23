module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        HIGH    = 2'b01,
        LOW_END = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        // Default next state is current state
        next_state = state;
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (data_in == 1'b0)
                    next_state = LOW_END;
                else if (data_in == 1'b1)
                    next_state = HIGH; // remain in HIGH if still high
                else
                    next_state = IDLE; // fallback
            end
            LOW_END: begin
                // After outputting pulse detection, go back to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output update on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            if (state == LOW_END)
                data_out <= 1'b1; // output pulse detected signal
            else
                data_out <= 1'b0;
        end
    end

endmodule