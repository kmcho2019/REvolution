module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

always @(posedge clk) begin
    // Right shift the contents of q by one bit and insert the new input bit d into the most significant position
    q <= {d, q[7:1]};
end

// Initial value of q can be set here, but it is more common to let the reset logic handle this in a real design
// initial q = 8'd0;

endmodule