module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    enum logic [1:0] {A, B, C1, C2, C3, D1, D2} state, next_state;

    always_ff @(posedge clk) begin
        if (~resetn) begin
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
                D1, D2: g <= 1;
                default: g <= 0;
            endcase
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            A: if (resetn) next_state = B;
            B: next_state = C1;
            C1: if (x) next_state = C2; else next_state = C1;
            C2: if (~x) next_state = C3; else next_state = C1;
            C3: if (x) next_state = D1; else next_state = C1;
            D1: if (y) next_state = D2; else next_state = D2;
            D2: next_state = D2;
            default: next_state = A;
        endcase
    end

endmodule