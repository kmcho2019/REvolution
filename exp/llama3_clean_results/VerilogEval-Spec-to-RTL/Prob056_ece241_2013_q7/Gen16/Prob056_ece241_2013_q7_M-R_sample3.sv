module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Combinational logic to determine the next state using continuous assignment
wire next_Q;
assign next_Q = ~k? (j? 1'b1 : Q) : (~j? 1'b0 : ~Q);

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule