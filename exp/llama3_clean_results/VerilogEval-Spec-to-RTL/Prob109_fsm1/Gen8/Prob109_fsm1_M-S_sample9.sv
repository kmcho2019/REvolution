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
        // asynchronous reset to state B (1)
        state <= 1'b1;
    end else begin
        // simplified next state logic
        state <= (state == 1'b1 && in == 1'b1) || (state == 1'b0 && in == 1'b1)? 1'b1 : 0;
    end
end

endmodule