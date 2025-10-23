module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit register to hold the state
assign out = state; // assign output as the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // asynchronous reset to state B
    end else begin
        case (state)
            1'b0: state <= in? 1'b0 : 1'b1; // Currently in state A
            1'b1: state <= in? 1'b1 : 1'b0; // Currently in state B
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

endmodule