module LFSR_Galois(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Internal signal to hold the next state calculation
reg [3:0] next_out;

// Combinational logic to calculate the next state
always @(*) begin
    // For simplicity, calculate the feedback as XOR of MSB and LSB
    // This is a basic example; in practice, taps would be chosen based on a polynomial
    next_out = {out[2:0], out[3] ^ out[0]};
end

// Handle the clock edge and reset conditions
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        out <= 4'b0;
    end else begin
        // Update the LFSR state with the calculated next state
        out <= next_out;
    end
end

endmodule