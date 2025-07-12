module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output logic out
);

    // State encoding using typedef enum (SystemVerilog)
    typedef enum logic {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, next_state;

    // Next-state logic: B->B on '1', B->A on '0'; A->A on '1', A->B on '0'
    // same as state ^ ~in
    assign next_state = state ^ ~in;

    // Enable state update only if next_state differs from current state to reduce toggling
    wire state_update_en = (next_state != state);

    // State register with asynchronous reset to B, state updates only if enabled
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else if (state_update_en)
            state <= next_state;
    end

    // Moore output directly assigned from current state
    assign out = state;

endmodule