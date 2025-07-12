// Module JC_counter: 64-bit Johnson counter using a ring buffer approach
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

reg [63:0] buffer; // Internal ring buffer

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        buffer <= 0;
    end else begin // Normal operation
        buffer <= {~buffer[0], buffer[63:1]}; // Update buffer
    end
    Q <= buffer; // Assign buffer value to output
end

endmodule