// Simplified TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
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

// Assign output
assign q = q_reg;

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        case ({load, ena})
            2'b11: q_reg <= data;  // Load takes priority over shift
            2'b10: q_reg <= {1'b0, q_reg[3:1]};  // Shift operation
            2'b01: q_reg <= {1'b0, q_reg[3:1]};  // Shift operation
            default: q_reg <= q_reg;  // No operation
        endcase
    end
end

endmodule