`define NUM_STATES 6

enum logic [1:0] {
    A,
    B,
    C,
    D,
    E,
    F
} state, next_state;

module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= w ? A : B;
            B: state <= w ? D : C;
            C: state <= w ? D : E;
            D: state <= w ? A : F;
            E: state <= w ? D : E;
            F: state <= w ? D : C;
            default: state <= A;
        endcase
    end
end

always @(state, w) begin
    case (state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = w;
        F: z = w;
        default: z = 0;
    endcase
end

endmodule