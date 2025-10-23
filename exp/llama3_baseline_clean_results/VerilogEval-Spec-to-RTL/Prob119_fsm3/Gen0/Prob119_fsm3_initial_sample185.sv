module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Enumerated type for states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// State register
state_t state, next_state;

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// State transition logic
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// State register update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule