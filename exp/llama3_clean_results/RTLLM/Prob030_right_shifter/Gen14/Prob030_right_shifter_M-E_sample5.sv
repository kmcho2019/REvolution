module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] queue;  // Array to simulate the FIFO queue
integer i;  // Index for the queue

// Initialize the queue to 0
initial queue = 8'd0;

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    // Push the new input bit into the queue
    queue[7] = d;
    // Shift the bits in the queue to the right
    for (i = 6; i >= 0; i--) begin
        queue[i] = queue[i + 1];
    end
    // Update q with the current state of the queue
    q <= queue;
end

endmodule