module Mux256to1 #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    // Direct bit selection - most efficient implementation
    assign out = in[sel];

endmodule