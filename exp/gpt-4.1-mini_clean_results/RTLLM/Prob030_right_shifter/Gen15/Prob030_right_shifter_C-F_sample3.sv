module right_shifter (
    input  wire       clk,  // Clock signal for synchronous operation
    input  wire       d,    // Serial input bit to be shifted in
    output reg  [7:0] q     // 8-bit output register showing shifted data
);

// Initialize q to zero at start of simulation
initial begin
    q = 8'b0;
end

// On every rising edge of clk, shift q right by one
// Insert input d into the MSB (q[7])
always @(posedge clk) begin
    q <= {d, q[7:1]};
end

endmodule