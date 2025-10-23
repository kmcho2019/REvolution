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

// Combinational logic for determining next state
always @(*) begin
    if (load) begin
        // Load data
        q_reg = data;
    end else if (ena) begin
        // Shift right
        q_reg = {1'b0, q_reg[3:1]};
    end else begin
        // No operation, maintain current state
        q_reg = q_reg;
    end
end

// However, the above combinational logic can't be used directly as it is. 
// Instead, let's use it as inspiration and simplify the original code
// by keeping the same functionality but in a more modular form.

// Sequential logic for register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Update register on positive edge of clock
        if (load) begin
            q_reg <= data;
        end else if (ena) begin
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

// Assign output
assign q = q_reg;

endmodule