module TopModule #
(
    parameter WIDTH = 1
)
(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin
        assign out[i] = a[i] & b[i];
    end
endgenerate

endmodule

module TopModuleWrapper(
    input  a,
    input  b,
    output out
);

TopModule #(.WIDTH(1)) u_top_module(
    .a(a),
    .b(b),
    .out(out)
);

endmodule