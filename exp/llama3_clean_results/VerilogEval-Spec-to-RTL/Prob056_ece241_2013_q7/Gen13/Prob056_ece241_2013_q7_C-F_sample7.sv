module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Combinational logic to determine the next state
reg next_Q;
assign next_Q = (j && ~k)? 1'b1 : (k && ~j)? 1'b0 : (~j && ~k)? Q : ~Q;

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule