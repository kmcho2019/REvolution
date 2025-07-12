module TopModule(
    input  in,
    output reg out
);

// Use an always block to assign the input to the output
always @(*)
    out = in;

endmodule