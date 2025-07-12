// Improved TopModule: Optimized 4-bit shift register solution
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]   q         // Output data
);

reg [3:0] q_reg;
reg        clk_gate; // Clock gate signal

// Clock gating logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        clk_gate <= 1'b0;
    end else begin
        // Enable clock gate when load or ena is high
        clk_gate <= load || ena;
    end
end

// Asynchronous reset, synchronous load and shift operations with clock gating
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else if (clk_gate) begin
        // Update the register on the positive edge of the clock
        if (load) begin
            // Load data into the register
            q_reg <= data;
        end else if (ena) begin
            // Shift right operation
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

// Assign output
assign q = q_reg;

endmodule