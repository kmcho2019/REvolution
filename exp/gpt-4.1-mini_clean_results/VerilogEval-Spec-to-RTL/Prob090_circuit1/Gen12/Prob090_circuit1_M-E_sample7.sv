module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Combinational logic: output 1 only if both a and b are 1; else 0
    assign q = (a == 1'b1 && b == 1'b1) ? 1'b1 : 1'b0;
endmodule