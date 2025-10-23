module JC_counter(
    input  clk,        // Clock signal
    input  rst_n,      // Active-low reset signal
    output [63:0] Q    // 64-bit register representing the current count value
);

reg [63:0] Q_reg;     // Internal register to hold the current count value

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        Q_reg <= 64'd0;  // Reset the counter value to 0
    end else begin
        if (Q_reg[0] == 1'b0) begin  // Least significant bit is 0, increment
            Q_reg <= {1'b1, Q_reg[63:1]};  // Shift right and append 1 at the most significant bit position
        end else begin  // Least significant bit is 1, decrement
            Q_reg <= {1'b0, Q_reg[63:1]};  // Shift right and append 0 at the most significant bit position
        end
    end
end

assign Q = Q_reg;  // Assign the internal register value to the output port

endmodule