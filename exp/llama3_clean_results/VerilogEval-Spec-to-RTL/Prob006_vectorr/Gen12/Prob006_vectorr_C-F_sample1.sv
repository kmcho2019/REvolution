// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

// Use an always block for clarity and modularity, even though it's combinational logic.
// This assigns the bits of the input to the output in reverse order.
always @(*) begin
    out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]}; // Note: Inputs are already given in reverse order for simplicity.
end

// This module is designed to be as minimalistic and efficient as possible.
// The bit reversal operation is performed directly, without any additional logic.
// This approach minimizes area usage and power consumption.

endmodule