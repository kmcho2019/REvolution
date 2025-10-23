module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

always @(posedge clk) begin
    // Perform right shift and insert new input bit with a single non-blocking assignment
    q <= {d, q[7:1]};
end

// Ensure q is initialized to 0 at power-up or reset to avoid undefined behavior
initial begin
    q = 8'd0;
end

endmodule