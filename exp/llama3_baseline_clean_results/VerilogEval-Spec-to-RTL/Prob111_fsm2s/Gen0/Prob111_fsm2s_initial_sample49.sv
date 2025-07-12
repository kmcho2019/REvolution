module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

enum logic [0:0] {OFF, ON} state, next_state;

always_comb begin
    case(state)
        OFF: next_state = (j == 1'b1) ? ON : OFF;
        ON:  next_state = (k == 1'b1) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule