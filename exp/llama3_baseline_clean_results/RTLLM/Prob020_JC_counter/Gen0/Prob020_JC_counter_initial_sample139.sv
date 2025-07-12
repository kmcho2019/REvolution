module JC_counter (
    input  clk,        // Clock signal
    input  rst_n,      // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active-low reset condition
        Q <= 64'd0;    // Reset counter value to 0
    end else begin
        if (Q[0] == 1'b0) begin  // If the least significant bit is 0, increment
            Q <= {1'b1, Q[63:1]};  // Shift current value to the right and append 1
        end else begin           // If the least significant bit is 1, decrement
            Q <= {1'b0, Q[63:1]};  // Shift current value to the right and append 0
        end
    end
end

endmodule