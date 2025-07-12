module TopModule (
    input clk,    // System clock (positive edge triggered)
    input a,      // Input signal
    output reg q  // Registered output (inverted 'a')
);

// Sequential logic: On each rising clock edge,
// output q becomes the inverse of input a
always @(posedge clk) begin
    q <= ~a;
end

endmodule