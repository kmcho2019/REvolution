module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_type;

state_type current_state, next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in? B : A;
            B: current_state <= in? B : C;
            C: current_state <= in? D : A;
            D: current_state <= in? B : C;
            default: current_state <= A;
        endcase
    end
end

always @(current_state) begin
    case (current_state)
        A: out <= 0;
        B: out <= 0;
        C: out <= 0;
        D: out <= 1;
        default: out <= 0;
    endcase
end

endmodule