module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,  // waiting for 0 to start pulse
        S1    = 2'b01,  // detected 0, waiting for 1
        S2    = 2'b10   // detected 0->1, waiting for final 0
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= 1'b0; // default output is 0
            // Output asserted only when detecting the final 0 in pulse sequence
            if (state == S2 && data_in == 1'b0)
                data_out <= 1'b1;
        end
    end

    // Next state logic
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
                    next_state = S1; // remain waiting for 1
                else
                    next_state = IDLE;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // pulse detected, go back to IDLE
                else if (data_in == 1'b1)
                    next_state = S2; // stay, as next pulse might start
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule