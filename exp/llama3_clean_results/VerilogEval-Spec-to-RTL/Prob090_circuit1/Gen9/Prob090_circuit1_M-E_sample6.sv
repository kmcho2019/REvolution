module TopModule(
    input  a,
    input  b,
    output q
);

    // Use a MUX to select the output based on the input combinations.
    assign q = (a == 1'b1)? b : 1'b0;

endmodule