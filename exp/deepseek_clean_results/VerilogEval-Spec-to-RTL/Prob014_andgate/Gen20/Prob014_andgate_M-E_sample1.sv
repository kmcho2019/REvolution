module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // MUX-based AND implementation
    assign out = a ? b : 1'b0;
endmodule