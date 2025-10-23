module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

typedef enum logic [0:0] {A, B} state_t;
state_t state, next_state;

always_comb begin
    case(state)
        A: next_state = (in) ? A : B;
        B: next_state = (in) ? B : A;
        default: next_state = B;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        A: out = 0;
        B: out = 1;
        default: out = 1;
    endcase
end

endmodule