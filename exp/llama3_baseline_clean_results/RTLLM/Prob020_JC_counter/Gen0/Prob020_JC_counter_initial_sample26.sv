module JC_counter(
    input clk,         // Clock signal
    input rst_n,       // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0 on active-low reset
        Q <= 64'd0;
    end else begin
        // Check the least significant bit (LSB) of the current count value
        if (Q[0] == 1'b0) begin
            // Increment the counter by shifting the current value to the right and appending a 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement the counter by shifting the current value to the right and appending a 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule