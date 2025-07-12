`default_nettype none

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);

    // Direct AND operation - most efficient implementation
    assign out = a & b;

endmodule