// Define the module for the 64-bit Johnson counter using a circular buffer
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

reg [5:0] write_ptr;  // Write pointer for the circular buffer
reg [5:0] read_ptr;   // Read pointer for the circular buffer
reg [63:0] buffer;    // Circular buffer to store the bits

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    // Reset condition: Initialize the pointers and buffer when rst_n is low
    if (~rst_n) begin
        write_ptr <= 6'd0;
        read_ptr <= 6'd0;
        buffer <= 64'd0;
    end else begin
        // Update the write pointer and buffer based on the current state (Q[0])
        if (buffer[0] == 1'b0) begin
            buffer <= {1'b1, buffer[63:1]};
        end else begin
            buffer <= {1'b0, buffer[63:1]};
        end
        Q <= buffer;
    end
end

endmodule