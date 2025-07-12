module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Always block to handle the reset and right shift operation
always @(posedge clk) begin
    if (!clk) begin // Ensure q is reset when clk is not high (assuming active high clk)
        q <= 8'd0;
    end else begin
        q <= {d, q[7:1]};  // Shift q to the right by one bit and insert d into the most significant position
    end
end

endmodule