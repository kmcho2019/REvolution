module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shared expressions for adjacent bits
    wire [2:0] both_bits = in[2:0] & in[3:1];
    wire [2:0] any_bits = in[3:1] | in[2:0];

    assign out_both = {1'b0, both_bits};      // out_both[3] unused
    assign out_any = {any_bits, 1'b0};        // out_any[0] unused
    assign out_different = in ^ {in[0], in[3:1]};  // Circular XOR

endmodule