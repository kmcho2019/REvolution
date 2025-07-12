/*
 * TopModule: Implements a combinational AND gate
 * Output q is high only when both inputs a and b are high
 */
module TopModule (
    input  a,
    input  b,
    output q
);
    // Explicit AND operation for clear functionality
    assign q = a & b;
endmodule