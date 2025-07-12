module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states as an enumeration for clarity
enum logic [1:0] {A, B, C, D} state, nextState;

// Combinational logic for next state and output
always_comb begin
    case(state)
        A: nextState = (in) ? B : A;
        B: nextState = (in) ? B : C;
        C: nextState = (in) ? D : A;
        D: nextState = (in) ? B : C;
    endcase
    out = (state == D) ? 1'b1 : 1'b0; // Output is '1' only in state D
end

// Sequential logic for state update
always_ff @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to state A
        state <= A;
    end else begin
        state <= nextState;
    end
end

endmodule