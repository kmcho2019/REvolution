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
        state <= (state == 1'b0)? ~in : in; // Simplified next state logic
    end
end

endmodule