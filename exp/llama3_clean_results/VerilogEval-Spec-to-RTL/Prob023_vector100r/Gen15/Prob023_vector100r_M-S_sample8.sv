module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    assign out = {<<{in}}; // Reverses the bit order of 'in' and assigns it to 'out'

endmodule