// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
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
reg [3:0] next_q_reg;

// Combinational logic to determine the next state
always @(*) begin
    if (load) begin
        // Load data into the register
        next_q_reg = data;
    end else if (ena) begin
        // Shift right operation
        next_q_reg = {1'b0, q_reg[3:1]};
    end else begin
        // Maintain the current state if neither load nor ena is asserted
        next_q_reg = q_reg;
    end
end

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Update the register on the positive edge of the clock
        q_reg <= next_q_reg;
    end
end

// Assign output
assign q = q_reg;

endmodule