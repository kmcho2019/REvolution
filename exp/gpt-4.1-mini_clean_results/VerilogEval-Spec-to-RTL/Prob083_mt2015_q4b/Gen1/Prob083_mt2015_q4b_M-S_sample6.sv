module TopModule(
    input x,
    input y,
    output z
);
    assign z = x ~^ y; // Use Verilog built-in xnor operator
endmodule