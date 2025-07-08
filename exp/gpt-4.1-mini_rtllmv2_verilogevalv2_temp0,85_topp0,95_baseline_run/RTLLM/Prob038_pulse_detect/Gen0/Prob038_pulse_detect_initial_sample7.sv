module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01,
        S2   = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state;
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
                    next_state = S1;
                else
                    next_state = IDLE; // Defensive, though data_in is 1 bit
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S1; // pulse ends here
                else if (data_in == 1'b1)
                    next_state = S2;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and output generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output logic: data_out asserted at end of pulse (on transition S2->S1)
            if (state == S2 && next_state == S1)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule