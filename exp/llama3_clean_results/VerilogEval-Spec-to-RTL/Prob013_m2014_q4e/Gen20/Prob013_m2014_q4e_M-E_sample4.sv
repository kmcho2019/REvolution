module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Internal signals for the inverted inputs
    wire inv_in1;
    wire inv_in2;
    wire and_out;

    // Invert the inputs
    assign inv_in1 = ~in1;
    assign inv_in2 = ~in2;

    // AND the inverted inputs
    assign and_out = inv_in1 & inv_in2;

    // Invert the AND output to get the NOR output
    assign out = ~and_out;
endmodule