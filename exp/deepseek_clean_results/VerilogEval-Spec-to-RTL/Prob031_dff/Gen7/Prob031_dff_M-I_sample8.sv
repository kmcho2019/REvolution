module TopModule (
    input clk,    // Clock input
    input d,     // Data input
    output reg q  // Output register
);

// Positive-edge triggered D flip-flop
always @(posedge clk) begin
    q <= d;
end

endmodule