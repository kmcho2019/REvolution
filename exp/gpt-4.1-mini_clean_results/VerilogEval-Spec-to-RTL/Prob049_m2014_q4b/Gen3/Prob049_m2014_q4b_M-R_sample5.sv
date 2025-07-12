module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset block: clears q when ar is asserted
always @(posedge ar or negedge ar) begin
    if (ar)
        q <= 0;
end

// Clocked data capture block: updates q on positive clock edge if not reset
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule