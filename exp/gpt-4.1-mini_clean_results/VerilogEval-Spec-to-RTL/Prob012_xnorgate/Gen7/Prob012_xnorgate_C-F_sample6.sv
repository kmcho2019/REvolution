module TopModule (
    input wire a,
    input wire b,
    output wire out
);

// Implement XNOR gate using built-in bitwise XNOR operator for optimal synthesis
assign out = a ^~ b;

endmodule