module right_shifter(
    input clk, // clock signal
    input d,   // input signal to be right-shifted
    output reg [7:0] q  // output signal representing the result of the right shift operation
);

initial q = 8'b0; // initialize q to 0

always @ (posedge clk) begin
    // Shift the current state to the right by one bit and insert the new input bit at the most significant position
    q <= {d, q[7:1]};
end

endmodule