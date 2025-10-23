module TopModule(
    input  in,
    output out
);
    // Direct implementation of a NOT gate using an assign statement.
    // This is the most straightforward and efficient way to implement a NOT gate in Verilog.
    assign out = ~in;
endmodule