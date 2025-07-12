module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg next_q;

// Combinational logic for next state
always @(*) begin
    if (r)
        next_q = 1'b0;
    else
        next_q = d;
end

// Sequential element (flip-flop)
always @(posedge clk) begin
    q <= next_q;
end

endmodule