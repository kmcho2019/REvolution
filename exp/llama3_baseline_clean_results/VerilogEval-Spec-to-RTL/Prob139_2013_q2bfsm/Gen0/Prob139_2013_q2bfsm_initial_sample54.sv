module TopModule (
    input        clk,
    input        resetn,
    input        x,
    input        y,
    output       f,
    output       g
);

enum logic [2:0] {A, B, C, D, E, F, G} state, next_state;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            A: f <= 0;
            B: f <= 1;
            default: f <= 0;
        endcase
        case (state)
            A, B, C, D: g <= 0;
            E, F, G: g <= 1;
        endcase
    end
end

always_comb begin
    next_state = state;
    case (state)
        A: if (resetn) next_state = B;
        B: next_state = C;
        C: if (x) next_state = D;
           else next_state = C;
        D: if (!x) next_state = E;
           else next_state = D;
        E: if (x) next_state = F;
           else next_state = E;
        F: if (y) next_state = G;
           else if (state == F) next_state = G;
           else next_state = F;
        G: next_state = G;
    endcase
end

endmodule