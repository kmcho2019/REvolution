module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Improved implementation using direct NOR logic
    assign out = ~in1 & ~in2;
endmodule