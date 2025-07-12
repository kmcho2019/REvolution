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
wire [3:0] next_q;

// Combinational logic for next state calculation
assign next_q = (load)? data : (ena)? {1'b0, q_reg[3:1]} : q_reg;

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Update the register on the positive edge of the clock
        q_reg <= next_q;
    end
end

// Assign output
assign q = q_reg;

endmodule