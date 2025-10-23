// Parameterized module to reverse the bit ordering of a vector using a barrel shifter
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    // Define the rotation amount for the barrel shifter
    localparam ROTATE_AMOUNT = WIDTH - 1;
    
    // Use a barrel shifter to reverse the bits
    always @(in) begin
        out = {in[WIDTH-1], in[WIDTH-2], in[WIDTH-3], in[WIDTH-4], in[WIDTH-5], in[WIDTH-6], in[WIDTH-7], in[0]};
    end
endmodule