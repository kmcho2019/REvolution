module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// State register with asynchronous reset
reg state;
always @(posedge clk or posedge areset) begin
    if(areset) state <= 1'b0;
    else state <= (state && !k) || (j && !state);
end

// Output logic
assign out = state;

endmodule