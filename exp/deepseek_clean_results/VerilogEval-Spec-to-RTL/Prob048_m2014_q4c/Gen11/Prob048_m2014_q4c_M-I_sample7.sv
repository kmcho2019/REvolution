module TopModule (
    input  clk,  // Clock
    input  d,    // Data input
    input  r,    // Synchronous reset (active high)
    output reg q  // Data output
);

// D flip-flop with synchronous reset to 0
always @(posedge clk) begin
    if (r) q <= 1'b0;
    else   q <= d;
end

endmodule