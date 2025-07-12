module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Intermediate wires to clearly indicate slicing intent
    wire [7:0] upper_byte = in[15:8];
    wire [7:0] lower_byte = in[7:0];

    assign out_hi = upper_byte;
    assign out_lo = lower_byte;

endmodule