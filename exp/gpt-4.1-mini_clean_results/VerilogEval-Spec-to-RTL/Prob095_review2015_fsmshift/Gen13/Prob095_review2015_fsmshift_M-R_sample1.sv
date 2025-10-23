module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    typedef enum logic [0:0] {IDLE = 1'b0, ENABLE = 1'b1} state_t;
    state_t state, next_state;

    reg [2:0] counter;
    reg [2:0] next_counter;

    // FSM state and counter registers
    always @(posedge clk) begin
        if (reset) begin
            state   <= ENABLE;
            counter <= 3'd4;
        end else begin
            state   <= next_state;
            counter <= next_counter;
        end
    end

    // Next state and counter logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Once enabled period finishes, remain in IDLE forever
                next_state   = IDLE;
                next_counter = 3'd0;
            end

            ENABLE: begin
                if (counter != 0) begin
                    next_state   = ENABLE;
                    next_counter = counter - 1;
                end else begin
                    next_state   = IDLE;
                    next_counter = 3'd0;
                end
            end

            default: begin
                next_state   = IDLE;
                next_counter = 3'd0;
            end
        endcase
    end

    // Output logic: shift_ena is high during ENABLE state with nonzero counter
    assign shift_ena = (state == ENABLE) && (counter != 0);

endmodule