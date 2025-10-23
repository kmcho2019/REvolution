module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // If the reset signal is low, reset the counter value to 0
        Q <= 64'd0;
    end else begin
        // If the least significant bit is 0, increment the counter
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};
        end 
        // If the least significant bit is 1, decrement the counter
        else if (Q[0] == 1'b1) begin
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule