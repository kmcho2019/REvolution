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

// LUT-based next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Synchronous operations
        case ({load, ena})
            2'b00: begin
                // No operation
                q_reg <= q_reg;
            end
            2'b01: begin
                // Synchronous shift right operation
                q_reg <= {1'b0, q_reg[3:1]};
            end
            2'b10: begin
                // Synchronous load with higher priority
                q_reg <= data;
            end
            2'b11: begin
                // Load has higher priority than shift
                q_reg <= data;
            end
        endcase
    end
end

// Assign output
assign q = q_reg;

endmodule