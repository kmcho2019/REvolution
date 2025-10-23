module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Use 2-to-1 multiplexers to select between the current state and its complement
// and between the output of the first multiplexer and the input values j and k
reg Q_bar;
always @(*) begin
    Q_bar = ~Q;
end

wire next_Q;
assign next_Q = (j & ~k)? 1'b1 : 
                 (~j & k)? 1'b0 : 
                 (j & k)? Q_bar : Q;

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule