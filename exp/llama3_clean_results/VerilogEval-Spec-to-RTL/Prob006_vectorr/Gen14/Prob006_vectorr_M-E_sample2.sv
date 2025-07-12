// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a combinational always block to reverse the input vector
    always @(*) begin
        out = 8'd0; // Initialize output vector to zero
        for (int i = 0; i < 8; i++) begin
            // Shift the current bit from the input vector into its correct position in the output vector
            out[i] = in[7 - i];
        end
    end

    // This module uses a loop to reverse the input vector, offering an alternative to direct assignment.
    // The loop iterates over the input bits, shifting each bit into its correct position in the output vector.
endmodule