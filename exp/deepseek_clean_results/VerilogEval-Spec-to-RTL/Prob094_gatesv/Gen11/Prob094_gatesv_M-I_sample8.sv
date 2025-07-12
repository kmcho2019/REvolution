module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Compute adjacent bits simultaneously
    wire [2:0] both_bits = in[2:0] & in[3:1];
    wire [2:0] any_bits = in[3:1] | in[2:0];

    assign out_both = {1'bx, both_bits};  // Explicit don't-care for MSB
    assign out_any = {any_bits, 1'bx};    // Explicit don't-care for LSB
    assign out_different = in ^ {in[0], in[3:1]};  // Efficient wrap-around XOR

endmodule