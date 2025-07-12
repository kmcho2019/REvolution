// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use an always block for procedural logic
    always @(*) begin
        // Reverse the bits of the input vector
        out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    end

    // This module is designed to be as minimalistic and efficient as possible.
    // The bit reversal operation is performed directly, without any additional logic.
    // This approach minimizes area usage and power consumption.
endmodule