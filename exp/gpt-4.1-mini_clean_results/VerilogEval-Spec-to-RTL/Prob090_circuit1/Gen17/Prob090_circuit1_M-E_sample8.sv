module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // If 'a' is 1, output is 'b'; else output 0
    assign q = a ? b : 1'b0;
endmodule