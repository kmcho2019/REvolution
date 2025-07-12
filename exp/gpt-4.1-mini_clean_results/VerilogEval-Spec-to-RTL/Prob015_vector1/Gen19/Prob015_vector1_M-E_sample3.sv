module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Intermediate wires to hold the high and low byte slices
    wire [7:0] high_byte;
    wire [7:0] low_byte;

    // Buffer the input into intermediate slices for clarity
    assign high_byte = in[15:8];
    assign low_byte  = in[7:0];

    // Assign output ports from intermediate wires
    assign out_hi = high_byte;
    assign out_lo = low_byte;

endmodule