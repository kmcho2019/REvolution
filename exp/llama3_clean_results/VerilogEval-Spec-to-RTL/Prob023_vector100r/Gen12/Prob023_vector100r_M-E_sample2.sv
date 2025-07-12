module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    wire [WIDTH-1:0] temp_out;
    wire [WIDTH-1:0] reversed_in;

    // Calculate the shift amount for bit reversal
    localparam SHIFT_AMOUNT = WIDTH - 1;

    // Use a Barrel Shifter to reverse the bits
    assign temp_out = (in << SHIFT_AMOUNT) | (in >> (WIDTH - SHIFT_AMOUNT));

    // Since the shift amount is the width minus one, the bits are reversed
    assign reversed_in = temp_out;

    // Assign the reversed bits to the output
    assign out = reversed_in;

endmodule