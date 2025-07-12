// Refactored LFSR implementation with improved structure
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Next state logic (combinational)
reg [3:0] next_state;
assign next_state = {out[2:0], ~(out[3] ^ out[2])};

// Sequential logic (register update)
always @(posedge clk) begin
    if (rst) begin
        // Reset to zero
        out <= 4'b0;
    end else begin
        // Update register with next state
        out <= next_state;
    end
end

endmodule