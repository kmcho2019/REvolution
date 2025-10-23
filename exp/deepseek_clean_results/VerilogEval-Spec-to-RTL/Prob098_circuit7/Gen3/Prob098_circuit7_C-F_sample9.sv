module TopModule (
    input clk,    // System clock (positive edge triggered)
    input a,      // Input signal
    output reg q  // Registered output
);

// Sequential logic with synchronous reset (active high)
// Output q is the inverted version of input a, sampled at clock edges
always @(posedge clk) begin
    q <= ~a;  // Invert input and register output
end

endmodule