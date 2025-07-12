module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] shift_reg;  // Register to store the shifted value of q
reg initialized;  // Flag to indicate if q has been initialized

always @(posedge clk) begin
    if (!initialized) begin
        q <= 8'd0;  // Initialize q to 0
        initialized <= 1'b1;  // Set the initialized flag
    end else begin
        shift_reg <= {d, q[7:1]};  // Shift q by 1 bit and insert d into the most significant position
        q <= shift_reg;  // Update q with the shifted value
    end
end

endmodule