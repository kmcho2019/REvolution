module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);
    // Direct assign statement implementing the logic
    assign f = (~x3 & x2) | (x3 & x1);
endmodule