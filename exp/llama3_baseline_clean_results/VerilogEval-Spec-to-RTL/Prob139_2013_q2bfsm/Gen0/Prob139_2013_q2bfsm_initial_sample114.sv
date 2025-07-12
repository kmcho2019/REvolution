module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

enum logic [2:0] {A, B, C, D, E, F} state, next_state;

always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end
    else begin
        state <= next_state;
        case(state)
            A: f <= 0;
            B: f <= 1;
            C, D, E, F: f <= 0;
        endcase
        case(state)
            A, B, C, F: g <= 0;
            D: g <= 1;
            E: g <= 1;
        endcase
    end
end

always_comb begin
    case(state)
        A: if (~resetn) next_state = A;
            else next_state = B;
        B: next_state = C;
        C: if (x) next_state = C1;
            else next_state = C;
        C1: if (~x) next_state = C2;
            else next_state = C;
        C2: if (x) next_state = D;
            else next_state = C;
        D: next_state = D1;
        D1: if (y) next_state = E;
            else if (~y) next_state = D2;
            else next_state = D1;
        D2: if (y) next_state = E;
            else next_state = F;
        E: next_state = E;
        F: next_state = F;
        default: next_state = A;
    endcase
end

enum logic [1:0] {C, C1, C2} count_state, next_count_state;

always_ff @(posedge clk) begin
    if (~resetn) begin
        count_state <= C;
    end
    else begin
        count_state <= next_count_state;
    end
end

always_comb begin
    case(count_state)
        C: if (x) next_count_state = C1;
            else next_count_state = C;
        C1: if (~x) next_count_state = C2;
            else next_count_state = C;
        C2: if (x) next_count_state = C;
            else next_count_state = C;
        default: next_count_state = C;
    endcase
end

endmodule