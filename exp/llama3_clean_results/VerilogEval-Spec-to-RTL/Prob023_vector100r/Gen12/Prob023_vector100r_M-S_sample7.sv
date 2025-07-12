module TopModule #(
    parameter INPUT_SIZE = 100
) (
    input  [INPUT_SIZE-1:0] in,
    output [INPUT_SIZE-1:0] out
);

    assign out = {<< {in} };

endmodule