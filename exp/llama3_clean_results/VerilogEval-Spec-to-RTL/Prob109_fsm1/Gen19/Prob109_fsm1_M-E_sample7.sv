module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Define states as an enumeration
    enum logic [0:0] {STATE_A, STATE_B} current_state, next_state;

    // Combinational logic to determine the next state
    always_comb begin
        case (current_state)
            STATE_A: next_state = in ? STATE_A : STATE_B;
            STATE_B: next_state = in ? STATE_B : STATE_A;
            default: next_state = STATE_B; // Default to state B
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_B; // Asynchronously reset to state B
        end else begin
            current_state <= next_state;
        end
    end

    // Assign output based on the current state
    assign out = (current_state == STATE_B) ? 1'b1 : 1'b0;

endmodule