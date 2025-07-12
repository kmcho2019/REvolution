module TopModule(
    input           clk,
    input           areset,
    input           in,
    output logic    out
);

// Define the states as an enum with explicit casting
typedef enum logic [1:0] {
    A = logic'('0),
    B = logic'('1),
    C = logic'(2),
    D = logic'(3)
} state_t;

state_t state, next_state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule