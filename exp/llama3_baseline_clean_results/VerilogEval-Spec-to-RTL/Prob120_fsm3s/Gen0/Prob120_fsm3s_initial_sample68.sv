module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [1:0] {A, B, C, D} state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// Sequential logic to update the state and output
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule