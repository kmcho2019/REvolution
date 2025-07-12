module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    // Use arithmetic addition which automatically handles carries
    assign sum = x + y;

endmodule