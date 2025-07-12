module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // Define states
    typedef enum logic [1:0] {
        IDLE  = 2'b00, // waiting for 0
        S1    = 2'b01, // got 0, waiting for 1
        S2    = 2'b10  // got 0->1, waiting for 0 to complete pulse
    } state_t;

    state_t state, next_state;

    // Next state logic and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Default output
            data_out <= 1'b0;
            // Set data_out = 1 only when pulse detected
            if (state == S2 && data_in == 1'b0)
                data_out <= 1'b1;
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b1)
                    next_state = S2;
                else if (data_in == 1'b0)
                    next_state = S1; // stay here while data_in is 0
                else
                    next_state = IDLE; // fallback
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S1; // pulse complete, go back to S1 because data_in=0
                else if (data_in == 1'b1)
                    next_state = S2; // still waiting for falling edge
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule