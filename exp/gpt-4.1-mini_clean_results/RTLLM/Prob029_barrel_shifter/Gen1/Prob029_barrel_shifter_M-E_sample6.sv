module barrel_shifter(
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output wire [7:0] out
);

    // Double the input bits concatenated to itself
    wire [15:0] doubled_in = {in, in};

    // Calculate rotated output as a slice from doubled_in
    // Rotation right by ctrl means taking bits [7+ctrl : ctrl]
    assign out = doubled_in[7 + ctrl -: 8];

endmodule