module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // This is the Verilog operator for XNOR
endmodule