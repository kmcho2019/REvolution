module LFSR(
    input clk,    // Clock signal
    input rst,    // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] out_reg; // Internal register to hold the state of the LFSR

// Feedback calculation: XOR of MSB and second MSB, then invert
assign out = out_reg;

always @ (posedge clk) begin
    if (rst) begin // Active high reset
        out_reg <= 4'b0000; // Initialize to zero
    end else begin
        // Calculate feedback: XOR of MSB (out_reg[3]) and second MSB (out_reg[2]), then invert
        reg feedback;
        assign feedback = ~(out_reg[3] ^ out_reg[2]);
        
        // Shift bits to the left and insert feedback at LSB
        out_reg <= {out_reg[2:0], feedback};
    end
end

endmodule