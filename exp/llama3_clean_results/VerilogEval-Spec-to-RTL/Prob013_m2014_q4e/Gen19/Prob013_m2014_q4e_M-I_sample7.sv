module TopModule(
    input  in1,
    input  in2,
    output out
);
    // The existing implementation is already efficient and straightforward.
    // To maintain simplicity and efficiency, we retain the direct NOR gate implementation.
    assign out = ~(in1 | in2);
endmodule