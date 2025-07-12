module JC_counter (
    input  clk,          // Clock signal
    input  rst_n,        // Active-low reset signal
    output [63:0] Q      // 64-bit register representing the current count value
);

reg [63:0] Q_reg;        // Internal register to hold the current count value
reg [63:0] Q_next;      // Next state of the count value

// Initialize the internal register with the current count value
always @(*) begin
    Q = Q_reg;
end

// Update the count value on every rising edge of the clock signal or the falling edge of the reset signal
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin        // Reset condition
        Q_reg <= 64'd0;      // Set the counter value to 0
    end else begin
        if (Q_reg[0] == 1'b0) begin  // Least significant bit is 0, increment the counter
            Q_reg <= {1'b1, Q_reg[63:1]};
        end else begin              // Least significant bit is 1, decrement the counter
            Q_reg <= {1'b0, Q_reg[63:1]};
        end
    end
end

endmodule