module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        GOT1,
        GOT11,
        GOT110,
        FOUND
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Sequential state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? GOT11 : GOT110;
            GOT110: next_state = data ? FOUND : IDLE;
            FOUND:  next_state = FOUND; // Stay in FOUND until reset
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else begin
            start_shifting <= (next_state == FOUND);
        end
    end

endmodule