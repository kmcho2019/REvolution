module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              sel,
    output [WIDTH-1:0] out
);

    // Explicit wire declaration
    wire [WIDTH-1:0] out;

    // Case statement implementation
    assign out = (sel == 1'b1) ? b : a;

endmodule