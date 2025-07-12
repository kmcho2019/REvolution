module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct XNOR operation without additional module instantiation
    assign out = ~(a ^ b);
endmodule