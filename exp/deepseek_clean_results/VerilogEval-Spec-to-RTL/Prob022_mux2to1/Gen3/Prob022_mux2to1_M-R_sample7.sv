module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    // Continuous assignment implementation
    assign out = sel ? b : a;
endmodule