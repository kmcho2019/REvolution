module right_shifter (
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'b0;

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    q <= {d, q[7:1]};  // Shift q to the right and insert d into the most significant position
end

endmodule