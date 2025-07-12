module TopModule (
    input  wire in,
    output wire out
);
    // Direct combinational inversion with continuous assignment
    assign out = ~in;
endmodule