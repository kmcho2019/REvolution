// TopModule: Top-level module
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

    reg [3:0] q_reg; // Register to store the current state of the shift register
    assign q = q_reg; // Assign output to the current state of the shift register

    // Asynchronous reset, synchronous load and shift operations
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: reset the shift register to zero
            q_reg <= 4'b0;
        end else if (load) begin
            // Synchronous load operation: load the input data into the shift register
            q_reg <= data;
        end else if (ena) begin
            // Synchronous shift operation: shift the shift register to the right
            q_reg <= {1'b0, q_reg[3:1]};
        end else begin
            // No operation: hold the current state of the shift register
            q_reg <= q_reg;
        end
    end

endmodule