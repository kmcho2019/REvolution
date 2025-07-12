// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a combinational always block for clarity and flexibility.
    always @(*) begin
        // Initialize the output vector.
        out = 8'b0;
        
        // Loop through each bit of the input vector and assign it to the corresponding reversed bit in the output vector.
        for (int i = 0; i < 8; i++) begin
            out[i] = in[7 - i];
        end
    end

    // This module is designed to be as minimalistic and efficient as possible.
    // The bit reversal operation is performed directly, without any additional logic.
    // This approach minimizes area usage and power consumption.

endmodule