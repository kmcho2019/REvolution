module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;

always @(posedge clk) begin
    q <= {d, q[7:1]};
end

endmodule