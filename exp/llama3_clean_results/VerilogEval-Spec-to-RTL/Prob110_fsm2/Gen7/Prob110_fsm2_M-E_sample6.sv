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
    else if(state == 1'b0 && j) state <= 1'b1;
    else if(state == 1'b1 && k) state <= 1'b0;
end

// Output logic
assign out = state;

endmodule