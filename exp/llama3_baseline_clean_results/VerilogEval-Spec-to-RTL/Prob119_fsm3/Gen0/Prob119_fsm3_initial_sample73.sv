module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

enum logic [1:0] {A, B, C, D} state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: if (!in) state <= A; else state <= B;
            B: if (!in) state <= C; else state <= B;
            C: if (!in) state <= A; else state <= D;
            D: if (!in) state <= C; else state <= B;
        endcase
    end
end

always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule