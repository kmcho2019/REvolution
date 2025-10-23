module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] buffer;  // Circular buffer to store the bits
integer pointer;  // Pointer to keep track of the current position

initial begin
    buffer = 8'd0;  // Initialize the buffer to 0
    pointer = 0;  // Initialize the pointer to 0
end

always @(posedge clk) begin
    // Calculate the index at which the new bit should be inserted
    integer index = pointer;
    // Update the buffer
    buffer[index] = d;
    // Update the pointer
    pointer = (pointer + 1) % 8;
    // Update the output q
    q = buffer;
end

endmodule