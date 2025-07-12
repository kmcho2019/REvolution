module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE   = 1'b0,
        ENABLE = 1'b1
    } state_t;

    state_t current_state, next_state;
    reg [2:0] count;  // 3-bit counter to count down from 4

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= ENABLE;
            count <= 3'd4; // start counting 4 cycles on reset
        end else begin
            current_state <= next_state;
            if (current_state == ENABLE && count != 0) begin
                count <= count - 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:   next_state = IDLE; // stay idle forever
            ENABLE: next_state = (count == 1) ? IDLE : ENABLE; // after 4 cycles, go to idle
            default: next_state = IDLE;
        endcase
    end

    // Output logic: shift_ena is high only in ENABLE state
    assign shift_ena = (current_state == ENABLE);

endmodule