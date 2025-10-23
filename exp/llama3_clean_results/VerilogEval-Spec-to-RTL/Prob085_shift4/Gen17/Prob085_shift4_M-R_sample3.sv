// TopModule: Refactored 4-bit shift register solution
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]   q         // Output data
);

reg [3:0] q_reg;

// Asynchronous reset
always @(posedge areset) begin
    // Reset register to zero
    q_reg <= 4'b0;
end

// Synchronous load and shift operations
always @(posedge clk) begin
    if (!areset) begin
        // Update the register on the positive edge of the clock
        if (load) begin
            // Load data into the register
            q_reg <= data;
        end else if (ena) begin
            // Shift right operation
            q_reg <= {1'b0, q_reg[3:1]};
        end else begin
            // Hold current value
            q_reg <= q_reg;
        end
    end
end

// Assign output
assign q = q_reg;

endmodule