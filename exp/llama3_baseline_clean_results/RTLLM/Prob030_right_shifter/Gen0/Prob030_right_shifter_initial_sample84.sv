module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

initial q = 8'b0;  // Initialize q register to 0

always @(posedge clk) begin
    q[7:1] <= q[6:0];  // Right shift q by one bit
    q[0] <= 1'b0;      // The least significant bit will be 0 after right shift
    q[7] <= d;         // Insert the new input bit d into the most significant position
end

endmodule