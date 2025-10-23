module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register implemented as shift register with feedback
    reg [1:0] state;

    // Feedback logic for next state
    wire feedback_bit = 
        (~state[1] & ~state[0] & in) |  // A->B transition
        (~state[1] & state[0] & ~in) |  // B->C transition
        (state[1] & ~state[0] & in) |   // C->D transition
        (state[1] & state[0] & in);     // D->B transition

    wire hold_bit = 
        (~state[1] & ~state[0] & ~in) | // A->A transition
        (~state[1] & state[0] & in) |   // B->B transition
        (state[1] & ~state[0] & ~in);   // C->A transition

    wire next_state_bit = feedback_bit | hold_bit;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // Reset to state A
        end else begin
            state <= {state[0], next_state_bit};
        end
    end

    // Output is high only in state D (11)
    assign out = state[1] & state[0];

endmodule