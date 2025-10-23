module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states as an enumeration
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Current state register
state_t current_state;
state_t next_state;

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 1'bx;
    endcase
end

// Next state logic
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // Default to state A
    endcase
end

// Sequential logic for state register with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule