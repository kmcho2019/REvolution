module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output reg [7:0] q // Output signal representing the result of the right shift operation
);

reg [2:0] ptr; // Pointer to track the current position
reg [7:0] buffer; // Circular buffer to store the bits

initial begin
    q = 8'b0; // Initialize q to 0
    ptr = 3'b000; // Initialize pointer to 0
    buffer = 8'b0; // Initialize buffer to 0
end

always @ (posedge clk) begin
    // Insert the new input bit into the buffer
    buffer[ptr] <= d;
    
    // Update the pointer
    ptr <= (ptr + 1) % 8;
    
    // Update q with the current state of the buffer
    q <= buffer;
end

endmodule