module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Intermediate wire to hold split bytes
    wire [7:0] upper_byte;
    wire [7:0] lower_byte;

    // Assign upper and lower bytes using concatenation to emphasize structure
    assign {upper_byte, lower_byte} = in;

    // Assign outputs from intermediate wires
    assign out_hi = upper_byte;
    assign out_lo = lower_byte;

endmodule