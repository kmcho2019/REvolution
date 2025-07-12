module TopModule (
    input clk,    // Clock input
    input a,      // Data input
    output reg q   // Output (inverted version of a, sampled at clock edges)
);

// On each positive clock edge, output the inverted input
always @(posedge clk) begin
    q <= ~a;
end

endmodule