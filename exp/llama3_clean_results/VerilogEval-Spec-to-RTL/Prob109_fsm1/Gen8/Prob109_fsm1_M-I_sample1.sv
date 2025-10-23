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
            1'b0: state <= in ? 1'b0 : 1'b1; // In state A, stay on in=1, go to B on in=0
            1'b1: state <= in ? 1'b1 : 1'b0; // In state B, stay on in=1, go to A on in=0
            default: state <= 1'b1; // Default to state B for any other condition
        endcase
    end
end

endmodule