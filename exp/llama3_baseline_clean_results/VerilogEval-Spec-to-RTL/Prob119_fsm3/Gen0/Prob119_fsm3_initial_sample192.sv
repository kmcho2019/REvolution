module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // Default to A
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
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
        default: out = 0; // Default to 0
    endcase
end

endmodule