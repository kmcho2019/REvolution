module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // Define states
    typedef enum logic [2:0] {
        RESET,
        COUNT1,
        COUNT2,
        COUNT3,
        DONE
    } state_t;

    // State registers
    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            RESET:   next_state = COUNT1;
            COUNT1:  next_state = COUNT2;
            COUNT2:  next_state = COUNT3;
            COUNT3:  next_state = DONE;
            DONE:    next_state = DONE;
            default: next_state = RESET;
        endcase
    end

    // Output logic
    assign shift_ena = (current_state != DONE);

endmodule