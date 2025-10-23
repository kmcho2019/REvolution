module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg state; // 1 represents state B, 0 represents state A

always @(posedge clk or posedge areset)
begin
    if (areset) 
        state <= 1'b1; // Reset to state B
    else
        state <= ~in ? ~state : state; // Simplified next state logic
end

// Output logic remains straightforward
assign out = state;

endmodule