module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

typedef enum logic [2:0] {
    A,
    B,
    C,
    D,
    E,
    F
} state;

state current_state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
    endcase
end

always_comb begin
    case (current_state)
        A, B, C, D: z = 0;
        E, F: z = 1;
    endcase
end

endmodule