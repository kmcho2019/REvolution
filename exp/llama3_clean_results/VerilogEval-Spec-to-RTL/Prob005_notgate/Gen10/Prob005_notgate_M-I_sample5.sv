module TopModule(
    input  in,
    output out
);
    // The NOT gate is directly implemented using an assignment statement.
    // This is the most straightforward and efficient way to implement a NOT gate in Verilog.
    assign out = ~in;
endmodule