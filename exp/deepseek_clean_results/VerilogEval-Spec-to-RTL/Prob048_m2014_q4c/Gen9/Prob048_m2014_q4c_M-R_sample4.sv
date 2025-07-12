module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg next_q;

// Combinational logic for next state
always @(*) begin
    next_q = r ? 1'b0 : d;
end

// Sequential flip-flop
always @(posedge clk) begin
    q <= next_q;
end

// Initialize q for simulation
initial begin
    q = 1'b0;
end

endmodule