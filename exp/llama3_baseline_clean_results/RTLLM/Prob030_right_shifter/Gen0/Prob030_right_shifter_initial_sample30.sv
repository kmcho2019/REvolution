module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the register q to 0
initial q = 8'b0;

// Always block to shift the register on rising edge of the clock
always @ (posedge clk) begin
    // Right shift the register by 1 bit and insert the new input bit d into the most significant position
    q <= {d, q[7:1]};
end

endmodule