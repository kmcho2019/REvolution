module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} state, next_state;

// Sequential logic for state transitions
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
    endcase

    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule