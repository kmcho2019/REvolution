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
        state <= 1'b1; // reset to state B
    end else begin
        case (state)
            1'b0: state <= (in == 1'b0) ? 1'b1 : 1'b0; // transition from A to B on input 0, stay in A on input 1
            1'b1: state <= (in == 1'b0) ? 1'b0 : 1'b1; // transition from B to A on input 0, stay in B on input 1
        endcase
    end
end

endmodule