module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Implement AND using a conditional operator for clarity
    assign q = (a && b) ? 1'b1 : 1'b0;
endmodule