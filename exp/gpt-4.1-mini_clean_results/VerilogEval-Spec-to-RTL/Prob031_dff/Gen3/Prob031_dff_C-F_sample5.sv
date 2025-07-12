module TopModule(
    input clk,   // Clock input, positive-edge triggered
    input d,     // Data input
    output reg q // Flip-flop output (assumed corrected direction from input to output)
);

// On positive edge of clk, capture input d into q
always @(posedge clk) begin
    q <= d;
end

endmodule