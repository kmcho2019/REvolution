module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,  // Waiting for rising edge (data_in=1)
        HIGH = 2'b01,  // data_in=1 detected, waiting for falling edge
        LOW  = 2'b10   // data_in=0 detected after HIGH, pulse complete
    } state_t;

    state_t state, next_state;

    // FSM next state logic (pure combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                if (~data_in)
                    next_state = LOW;
                else
                    next_state = HIGH;
            end

            LOW: begin
                // After detecting pulse, check if new pulse starts immediately
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // FSM state and output update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out only when entering LOW state indicating pulse detected
            data_out <= (next_state == LOW) ? 1'b1 : 1'b0;
        end
    end

endmodule