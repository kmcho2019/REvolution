module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: if (~in) state <= A; else state <= B;
            B: if (~in) state <= C; else state <= B;
            C: if (~in) state <= A; else state <= D;
            D: if (~in) state <= C; else state <= B;
            default: state <= A;
        endcase
    end
end

always_comb begin
    case (state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule