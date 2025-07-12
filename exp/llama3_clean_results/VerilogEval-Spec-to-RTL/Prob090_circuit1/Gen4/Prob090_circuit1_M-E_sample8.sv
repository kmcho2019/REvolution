module TopModule(
    input  a,
    input  b,
    output q
);

    // Use a 2:1 MUX to select the output based on input 'a'.
    assign q = (a == 1'b1) ? b : 1'b0;

endmodule