// Refactored D Flip-Flop Module
module TopModule(
    input  clk,  // Clock input
    input  d,    // Data input
    output reg q  // Q output
);

// Update the output q with the input d at the positive edge of the clock clk
always @(posedge clk) begin
    // Direct assignment of d to q at the positive clock edge
    q <= d;
end

endmodule