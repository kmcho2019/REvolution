module JC_counter(
    input clk,    // Clock signal
    input rst_n,  // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter value to 0 when the reset signal is low
        Q <= 64'd0;
    end else begin
        // Update the counter value based on the least significant bit
        if (Q[0] == 1'b0) begin
            // If the least significant bit is 0, shift right and append a 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If the least significant bit is 1, shift right and append a 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule