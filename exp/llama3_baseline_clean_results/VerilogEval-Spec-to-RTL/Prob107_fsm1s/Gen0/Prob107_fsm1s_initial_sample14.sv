module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

typedef enum {A, B} state_type;
state_type current_state, next_state;

always @(*) begin
    case (current_state)
        A: if (!in) next_state = B;
           else next_state = A;
        B: if (!in) next_state = A;
           else next_state = B;
        default: next_state = B;
    endcase
end

always @(posedge clk) begin
    if (reset) current_state = B;
    else current_state = next_state;
end

always @(*) begin
    case (current_state)
        A: out = 0;
        B: out = 1;
        default: out = 1;
    endcase
end

endmodule