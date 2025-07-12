module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

initial q = 8'b0;  // Initialize q to 0

always @(posedge clk) begin
    reg [7:0] temp;  // Temporary variable to hold the result of the right shift operation
    temp = q >> 1;   // Right shift the contents of q by 1 bit
    temp[7] = d;     // Insert the new input bit d into the most significant position of temp
    q <= temp;       // Assign the value of temp back to q
end

endmodule