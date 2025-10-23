module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

enum logic [0:0] {OFF, ON} state, next_state;

always @(posedge clk) begin
    if (reset) state <= OFF;
    else state <= next_state;
end

always @(*) begin
    case (state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

assign out = (state == ON);

endmodule