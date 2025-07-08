module pulse_detect(
    input        clk,
    input        rst_n,
    input        data_in,
    output reg   data_out
);

    // Define states
    typedef enum reg [1:0] {
        IDLE  = 2'b00, // waiting for data_in=0
        S1    = 2'b01, // detected leading 0, waiting for 1
        S2    = 2'b10  // detected 0 then 1, waiting for final 0 to confirm pulse
    } state_t;

    state_t state, next_state;

    // State transition logic and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only in state S2 when data_in==0 (end of pulse)
            data_out <= (state == S2 && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
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
                    next_state = S1; // stay if still 0 (waiting for 1)
                else
                    next_state = IDLE; // fallback
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // pulse detected, return to IDLE
                else if (data_in == 1'b1)
                    next_state = S2; // waiting for 0 to finish pulse, stay in S2
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule