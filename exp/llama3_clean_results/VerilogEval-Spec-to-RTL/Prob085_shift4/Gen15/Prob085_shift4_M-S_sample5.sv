// Simplified TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

reg [3:0] q_reg = 4'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        case ({load, ena})
            2'b10: q_reg <= data;
            2'b01: q_reg <= {1'b0, q_reg[3:1]};
            default: q_reg <= q_reg;
        endcase
    end
end

assign q = q_reg;

endmodule