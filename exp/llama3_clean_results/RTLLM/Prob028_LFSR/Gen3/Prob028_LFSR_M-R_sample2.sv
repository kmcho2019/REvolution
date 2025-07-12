module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] next_out;  // Next state of the LFSR

// Calculate the feedback signal
assign next_out = {out[2:0], ~(out[3] ^ out[2])};

// Handle the clock edge and reset conditions
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        out <= 4'b0;
    end else begin
        // Update the LFSR state
        out <= next_out;
    end
end

endmodule