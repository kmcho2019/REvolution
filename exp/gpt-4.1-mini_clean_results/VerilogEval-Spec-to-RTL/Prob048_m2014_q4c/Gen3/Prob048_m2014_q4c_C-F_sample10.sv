module TopModule (
    input  clk,  // Clock input
    input  d,    // Data input
    input  r,    // Synchronous active-high reset
    output reg q // Output register
);

// On the rising edge of the clock,
// if reset is asserted, clear q to 0,
// otherwise capture the data input d.
always @(posedge clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= d;
end

endmodule