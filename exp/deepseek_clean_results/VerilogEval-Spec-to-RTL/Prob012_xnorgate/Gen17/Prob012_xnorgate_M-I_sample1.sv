module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    // Direct XNOR implementation that maps to single standard cell
    // Most efficient implementation for PPA in most technology libraries
    assign out = a ^~ b;
endmodule