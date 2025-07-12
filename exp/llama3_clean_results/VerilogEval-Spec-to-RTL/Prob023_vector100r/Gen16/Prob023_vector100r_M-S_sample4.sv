module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Directly assign the input bits to the output bits in reversed order
    assign out = {<< {WIDTH{1'b0}} >> in};

endmodule