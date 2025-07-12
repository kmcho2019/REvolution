module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);

// Implementing 2-input AND gate using continuous assignment
assign out = a & b;

endmodule