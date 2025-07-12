module TopModule (
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset
    input           load,       // Synchronous load signal
    input           ena,        // Synchronous enable signal
    input   [3:0]   data,       // 4-bit data input
    output  [3:0]   q           // 4-bit output
);

// 4-bit shift register
reg [3:0] q_reg;  // Register to hold the shift register's value

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Synchronous operations
        if (load) begin
            // Synchronous load with higher priority
            q_reg <= data;
        end else if (ena) begin
            // Synchronous shift right operation
            // Using a more efficient shift operation
            q_reg <= {1'b0, q_reg[3:1]};
        end else begin
            // No operation
            q_reg <= q_reg;
        end
    end
end

// Assign output
assign q = q_reg;

endmodule