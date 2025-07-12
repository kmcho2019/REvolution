module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
            C: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= D;
                end
            end
            D: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
        endcase
    end
end

always_comb begin
    case (state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
    endcase
end

endmodule