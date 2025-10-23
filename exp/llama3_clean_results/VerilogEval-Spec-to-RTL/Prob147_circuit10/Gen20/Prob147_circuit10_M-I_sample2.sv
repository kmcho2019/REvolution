module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case({a, b})
        2'b00: state <= 1'b1; // Transition to state 1 when a=0 and b=0
        2'b11: state <= 1'b0; // Transition to state 0 when a=1 and b=1
        default: state <= state; // Maintain current state for other combinations
    endcase
end

always @(*) begin
    if (state == 1'b1) begin
        q = 1'b1; // When state is 1, q is always 1
    end else begin
        q = b; // When state is 0, q follows b
    end
end

endmodule