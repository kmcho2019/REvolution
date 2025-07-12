module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct XNOR implementation using Verilog's built-in operator ~^
    assign out = a ~^ b;
endmodule