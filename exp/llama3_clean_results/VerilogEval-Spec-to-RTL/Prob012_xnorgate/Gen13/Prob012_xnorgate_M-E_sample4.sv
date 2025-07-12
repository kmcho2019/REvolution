module TopModule(
    input  a,
    input  b,
    output out
);

    // Implementing XNOR using a MUX
    assign out = (a == b) ? 1'b1 : 1'b0;

    // Alternatively, using a more explicit MUX-like structure
    // assign out = (a) ? (!b) : b;

    // Or explicitly using a MUX with inverted inputs
    // assign out = (a) ? (!b) : (!(!b));

endmodule