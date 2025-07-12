// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Internal signals for the circular buffer
reg [63:0] buffer;

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set buffer to 0 when rst_n is low
        buffer <= 64'd0;
    end else begin
        // Update buffer based on the value of buffer[0]
        buffer <= {buffer[63], buffer[62:1]};
        // Append a new bit to the buffer based on buffer[0]
        if (buffer[0] == 1'b0) begin
            buffer[63] <= 1'b1;
        end else begin
            buffer[63] <= 1'b0;
        end
    end
end

// Assign the output Q to the buffer
assign Q = buffer;

endmodule