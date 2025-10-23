module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Combinational logic for next state and output
always_comb begin
    case (current_state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
    endcase
    out = (current_state == D) ? 1'b1 : 1'b0; // Determine output based on current state
end

// Sequential logic for state update and reset
always_ff @(posedge clk) begin
    if (reset) begin // Active high reset
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule