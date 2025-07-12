module TopModule(
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Declare internal wires to hold the sliced bits of the input
    wire [7:0] temp_upper;
    wire [7:0] temp_lower;

    // Assign the sliced bits of the input to the internal wires
    assign temp_upper = in[15:8];
    assign temp_lower = in[7:0];

    // Assign the values of the internal wires to the output signals
    assign out_hi = temp_upper;
    assign out_lo = temp_lower;

endmodule