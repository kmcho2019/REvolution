module TopModule #(
    parameter WIDTH = 1
) (
    output [WIDTH-1:0] zero
);
    assign zero = {WIDTH{1'b0}};
endmodule