module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    assign out = {<<{WIDTH{1'b0}}}} in; // Reverse the bits of 'in' and assign to 'out'

endmodule