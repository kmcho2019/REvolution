// Modular LFSR module with explicit initialization and feedback logic
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Combinational logic block to calculate the feedback
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: update LFSR state
        // Shift the bits in the LFSR and insert the new feedback value
        out <= {out[2:0], feedback};
    end
end

endmodule