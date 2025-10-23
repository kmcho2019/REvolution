module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct assign of XNOR for minimal area and power
    assign out = ~(a ^ b);
endmodule