module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Using logic gates to implement the D flip-flop with synchronous reset
always @(posedge clk) begin
    q <= (d & ~r) | (1'b0 & r); // If r is high, output is 0, otherwise output is d
end

endmodule