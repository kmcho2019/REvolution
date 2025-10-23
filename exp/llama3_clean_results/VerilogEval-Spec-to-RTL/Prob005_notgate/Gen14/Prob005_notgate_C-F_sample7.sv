module TopModule(
    input  in,
    output out
);
    // Using the assign statement for efficiency and synthesis-friendliness
    assign out = ~in;
endmodule