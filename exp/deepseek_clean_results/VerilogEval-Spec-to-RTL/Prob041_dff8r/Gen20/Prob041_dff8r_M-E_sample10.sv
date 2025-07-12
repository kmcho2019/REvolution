module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    reg [2:0] bit_counter;  // 3-bit counter to track current bit position
    reg current_bit;        // Single DFF for the shift register

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset - clear all bits and reset counter
            q <= 8'b0;
            bit_counter <= 3'b0;
            current_bit <= 1'b0;
        end else begin
            // Shift in current bit from input
            current_bit <= d[bit_counter];
            
            // Update corresponding output bit
            q[bit_counter] <= current_bit;
            
            // Increment counter to process next bit
            bit_counter <= bit_counter + 1;
        end
    end

endmodule