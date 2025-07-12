module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Single always block for synchronous reset and flip-flop behavior
always @(posedge clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= d;
end

// Initialize q for simulation
initial begin
    q = 1'b0;
end

endmodule