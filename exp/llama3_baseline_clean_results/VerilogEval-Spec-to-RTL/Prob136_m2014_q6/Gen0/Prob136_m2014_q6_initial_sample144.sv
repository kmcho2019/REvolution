module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

enum logic [2:0] {A, B, C, D, E, F} state, next_state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
    endcase
end

always_comb begin
    case (state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
    endcase
end

endmodule