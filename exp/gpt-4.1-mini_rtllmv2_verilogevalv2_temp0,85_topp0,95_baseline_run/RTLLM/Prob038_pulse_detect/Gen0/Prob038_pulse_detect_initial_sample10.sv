module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,  // Waiting for first 0
        S0   = 2'b01,  // Detected 0, waiting for 1
        S1   = 2'b10   // Detected 0->1, waiting for 0 to complete pulse
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is set only when pulse completes (at end of S1 with data_in=0)
            if (state == S1 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else if (data_in == 1'b0)
                    next_state = S0; // stay waiting for 1
                else
                    next_state = IDLE; // default fallback (should not happen)
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S0; // pulse complete, go back to wait for next pulse
                else if (data_in == 1'b1)
                    next_state = S1; // stay waiting for 0 to complete pulse
                else
                    next_state = IDLE; // default fallback
            end
            default: next_state = IDLE;
        endcase
    end

endmodule