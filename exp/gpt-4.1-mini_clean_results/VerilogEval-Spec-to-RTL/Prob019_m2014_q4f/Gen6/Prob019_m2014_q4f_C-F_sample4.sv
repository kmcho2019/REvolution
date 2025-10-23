module TopModule (
    input  in1,
    input  in2,
    output out
);

    wire in2_inv;
    assign in2_inv = ~in2;      // Behavioral inversion for clarity and synthesis friendliness

    and U_and (out, in1, in2_inv); // Primitive AND gate with inverted input (bubble on in2)

endmodule