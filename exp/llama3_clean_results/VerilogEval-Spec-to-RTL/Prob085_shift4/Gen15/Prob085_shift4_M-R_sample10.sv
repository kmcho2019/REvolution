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

// Next state logic
wire [3:0] next_q;

// Assign next state based on load and ena signals
assign next_q = (load) ? data : (ena) ? {1'b0, q_reg[3:1]} : q_reg;

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Synchronous update of q_reg
        q_reg <= next_q;
    end
end

// Assign output
assign q = q_reg;

endmodule