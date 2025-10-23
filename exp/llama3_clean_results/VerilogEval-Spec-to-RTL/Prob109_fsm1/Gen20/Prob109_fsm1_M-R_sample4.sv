module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Enumerate states for better readability
    enum logic [0:0] {A, B} state, next_state;

    // Combinational logic for next state using case statement
    always_comb begin
        case (state)
            A: next_state = (in) ? A : B;
            B: next_state = (in) ? B : A;
            default: next_state = B; // Default to state B
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronously reset to state B
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // Directly assign output based on the state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule