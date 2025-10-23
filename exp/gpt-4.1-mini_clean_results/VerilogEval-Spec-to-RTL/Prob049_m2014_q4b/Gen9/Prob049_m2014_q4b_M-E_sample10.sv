module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset logic: immediately clear q when ar is asserted
always @(posedge ar or negedge ar) begin
    if (ar)
        q <= 1'b0;
end

// Data sampling on rising edge of clk, only if reset is not active
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule