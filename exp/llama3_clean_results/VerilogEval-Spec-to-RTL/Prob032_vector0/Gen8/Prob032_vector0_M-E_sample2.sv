module TopModule #(
    parameter WIDTH = 3
) (
    input [WIDTH-1:0] vec,
    output [WIDTH-1:0] outv,
    output [WIDTH-1:0] out_bits
);

    assign outv = vec;
    assign out_bits = vec;

endmodule

module TopModuleWrapper (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    wire [2:0] out_bits;

    TopModule #(.WIDTH(3)) top_module (
        .vec(vec),
        .outv(outv),
        .out_bits(out_bits)
    );

    assign o2 = out_bits[2];
    assign o1 = out_bits[1];
    assign o0 = out_bits[0];

endmodule