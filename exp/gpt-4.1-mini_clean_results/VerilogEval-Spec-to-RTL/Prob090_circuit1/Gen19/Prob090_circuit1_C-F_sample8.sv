module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND operation for minimal area, power, and delay
    assign q = a & b;
endmodule