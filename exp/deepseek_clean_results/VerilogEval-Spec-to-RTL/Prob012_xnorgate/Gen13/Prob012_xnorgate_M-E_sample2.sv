module TopModule (
    input a,
    input b,
    output out
);
    // Implement XNOR using a multiplexer
    assign out = a ? ~b : b;
endmodule