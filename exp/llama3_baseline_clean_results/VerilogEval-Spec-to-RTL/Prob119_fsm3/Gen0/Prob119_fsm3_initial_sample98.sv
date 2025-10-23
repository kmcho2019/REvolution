module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states as enumeration
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Declare current state and next state variables
state_t current_state;
state_t next_state;

// Combinational logic for next state and output
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase

    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// Sequential logic for updating current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule