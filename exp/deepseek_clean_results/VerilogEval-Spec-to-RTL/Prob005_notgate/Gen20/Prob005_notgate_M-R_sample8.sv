module TopModule (
    input wire in,
    output wire out
);
    // Direct implementation using continuous assignment
    assign out = ~in;
endmodule