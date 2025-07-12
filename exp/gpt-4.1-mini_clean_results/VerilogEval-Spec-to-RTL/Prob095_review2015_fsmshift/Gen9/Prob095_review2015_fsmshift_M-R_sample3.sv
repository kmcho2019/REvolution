module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high reset
    output wire shift_ena
);

    // FSM state encoding
    typedef enum logic [0:0] {
        IDLE   = 1'b0,
        ENABLE = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] counter, next_counter;

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state   <= ENABLE;
            counter <= 3'd4;
        end else begin
            state   <= next_state;
            counter <= next_counter;
        end
    end

    // FSM combinational next-state and counter logic
    always @(*) begin
        next_state   = state;
        next_counter = counter;

        case (state)
            ENABLE: begin
                if (counter != 0)
                    next_counter = counter - 1;
                if (counter == 1) // when counting down to zero next cycle
                    next_state = IDLE;
            end
            IDLE: begin
                // remain in IDLE forever until reset
                next_counter = 3'd0;
            end
        endcase
    end

    // Output logic directly from FSM state
    assign shift_ena = (state == ENABLE);

endmodule