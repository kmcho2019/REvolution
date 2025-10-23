module JC_counter (
    input           clk,         // Clock signal
    input           rst_n,       // Active-low reset signal
    output reg [63:0] Q          // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0
        Q <= 64'd0;
    end else begin
        // Check the least significant bit (Q[0]) and update Q
        if (Q[0] == 1'b0) begin
            // Increment: Shift Q[63:1] to the right and append a 1 at the most significant bit position
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: Shift Q[63:1] to the right and append a 0 at the most significant bit position
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule