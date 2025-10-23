module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as an enumeration
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Current state
state_t current_state;

// Next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A
        current_state <= A;
    end else begin
        // Next state logic based on the current state and input
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
        endcase
    end
end

// Output logic
always_comb begin
    // Determine the output based on the current state
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule