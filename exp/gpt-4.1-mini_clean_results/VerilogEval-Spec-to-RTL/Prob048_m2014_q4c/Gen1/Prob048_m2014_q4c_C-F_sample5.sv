module TopModule (
    input  clk,  // Clock input
    input  d,    // Data input
    input  r,    // Synchronous active-high reset
    output reg q // Output of the D flip-flop
);

always @(posedge clk) begin
    if (r)
        q <= 1'b0;  // On synchronous reset, clear output
    else
        q <= d;     // Otherwise, capture data input
end

endmodule