module TopModule(
    input  in,
    output out
);
    // Using a 2-to-1 MUX to implement a NOT gate
    // When in is 0, out is 1; when in is 1, out is 0
    assign out = in ? 0 : 1;
    // Alternatively, a more explicit MUX implementation could be:
    // assign out = (in == 1'b0) ? 1'b1 : 1'b0;
endmodule