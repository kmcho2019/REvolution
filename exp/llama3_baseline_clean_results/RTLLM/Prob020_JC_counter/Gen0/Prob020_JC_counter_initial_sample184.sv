module JC_counter(
    input clk,          // Clock signal
    input rst_n,        // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        Q <= 64'd0;   // Set counter value to 0
    end else begin
        if (Q[0] == 1'b0) begin // Increment condition
            Q <= {1'b1, Q[63:1]}; // Shift current value to the right and append 1
        end else begin
            Q <= {1'b0, Q[63:1]}; // Decrement condition: Shift current value to the right and append 0
        end
    end
end

endmodule