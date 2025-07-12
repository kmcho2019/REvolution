module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

// Initialize q to zero for simulation purposes only; synthesis tools may ignore this
initial q = 8'b0;

always @(posedge clk) begin
    // On each rising clock edge:
    // Shift q right by one bit and insert input bit d at the MSB position
    q <= {d, q[7:1]};
end

endmodule