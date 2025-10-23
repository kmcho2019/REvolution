module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Shift the input vector right by sel bits
    // The selected bit is the LSB of the shifted vector
    wire [255:0] shifted_in = in >> sel;
    assign out = shifted_in[0];
endmodule