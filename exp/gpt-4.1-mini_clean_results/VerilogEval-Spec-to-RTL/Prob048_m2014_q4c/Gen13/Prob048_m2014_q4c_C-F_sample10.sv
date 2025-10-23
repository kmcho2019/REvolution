module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Synchronous D flip-flop with active-high synchronous reset
always @(posedge clk) begin
    if (r) 
        q <= 1'b0;  // Reset output to 0 when r is asserted
    else 
        q <= d;     // Capture data input on rising edge of clk
end

endmodule