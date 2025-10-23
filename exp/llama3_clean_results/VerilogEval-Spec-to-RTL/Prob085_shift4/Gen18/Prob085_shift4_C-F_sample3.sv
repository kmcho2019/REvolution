// Superior TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// 4-bit shift register
reg [3:0] q_reg;

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    // Handle asynchronous reset
    if (areset) begin
        q_reg <= 4'b0; // Reset the shift register to zero
    end else begin
        // Handle clocked operations
        if (load) begin
            // Load data into the shift register
            q_reg <= data;
        end else if (ena) begin
            // Shift right operation
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

// Assign output
assign q = q_reg; // Output is the current state of the shift register

endmodule