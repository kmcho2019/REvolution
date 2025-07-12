module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // MUX-based implementation
    assign sum = b ? ~a : a;  // Sum is a when b=0, ~a when b=1
    assign cout = b ? a : 1'b0; // Carry is a when b=1, 0 otherwise

endmodule