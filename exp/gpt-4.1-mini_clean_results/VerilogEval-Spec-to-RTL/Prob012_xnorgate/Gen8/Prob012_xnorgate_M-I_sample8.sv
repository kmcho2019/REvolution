module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Use the direct bitwise XNOR operator for minimal and clear combinational logic
    assign out = a ~^ b;
endmodule