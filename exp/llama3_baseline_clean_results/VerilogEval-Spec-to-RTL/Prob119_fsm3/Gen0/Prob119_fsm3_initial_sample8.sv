module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states as enumeration
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Combinational logic to determine next state
always_comb begin
    case (state)
        A: next_state = (in == 1'b0)? A : B;
        B: next_state = (in == 1'b0)? C : B;
        C: next_state = (in == 1'b0)? A : D;
        D: next_state = (in == 1'b0)? C : B;
        default: next_state = A; // Default state
    endcase
end

// Sequential logic for state transition and output
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A; // Asynchronous reset to state A
    end else begin
        state <= next_state;
    end
end

// Output logic based on the current state
always_comb begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default output
    endcase
end

endmodule