module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        HIGH    = 2'b01,
        FALLING = 2'b10,
        WAIT    = 2'b11
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            HIGH:
                if (data_in == 1'b0)
                    next_state = FALLING;
                else
                    next_state = HIGH;
            FALLING:
                next_state = WAIT;
            WAIT:
                next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output pulse only in FALLING state (end of pulse)
            data_out <= (next_state == WAIT) ? 1'b1 : 1'b0;
        end
    end

endmodule