module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE      = 2'd0,
        HIGH      = 2'd1,
        PULSE_END = 2'd2
    } state_t;

    state_t state, next_state;

    // State transitions
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (data_in == 1'b0)
                    next_state = PULSE_END;
                else
                    next_state = HIGH;
            end
            PULSE_END: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = HIGH; // If pulse continues or a new pulse starts
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic with output generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Output logic: data_out is 1 only at end of pulse (transition 0->1->0)
            if (state == HIGH && next_state == PULSE_END)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule