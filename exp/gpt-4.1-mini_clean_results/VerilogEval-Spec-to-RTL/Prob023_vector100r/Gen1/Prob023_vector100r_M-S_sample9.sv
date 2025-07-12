module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out
);
    assign out = in[0 +: 100][::-1]; // SystemVerilog bit-reverse slice notation (if supported)

    // For pure Verilog-2001, use concatenation:
    // assign out = {in[0], in[1], ..., in[99]} in reversed order.
endmodule