module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Combinational logic to determine the next state
reg next_Q;
always @(*) begin
    next_Q = ~k? (j? 1'b1 : Q) : (~j? 1'b0 : ~Q);
end

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule