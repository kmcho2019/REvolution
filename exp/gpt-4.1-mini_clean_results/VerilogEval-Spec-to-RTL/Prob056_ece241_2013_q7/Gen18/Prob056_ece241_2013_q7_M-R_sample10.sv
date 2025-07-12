module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

// Combinational logic implementing JK flip-flop characteristic equation
assign next_Q = (j & ~Q) | (~k & Q);

initial begin
    Q = 0;
end

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule