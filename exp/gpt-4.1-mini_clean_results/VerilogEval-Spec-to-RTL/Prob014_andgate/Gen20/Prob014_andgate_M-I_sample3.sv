module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    // Directly assign AND of inputs to output
    assign out = a & b;
endmodule