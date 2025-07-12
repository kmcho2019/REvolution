module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states as an enumeration
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// Combinational logic to determine next state and output
always_comb begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
    endcase
    
    // Determine output based on current state
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// Sequential logic to update state on positive edge of clock
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset to state A on active high reset
        state <= A;
    end else begin
        // Update state
        state <= next_state;
    end
end

endmodule