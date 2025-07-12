module TopModule (
    input a,
    input b,
    output out
);
    // Implement XNOR using a 4:1 mux as a lookup table
    // selector[1] = a, selector[0] = b
    assign out = (a & b) ? 1'b1 :  // 11 case
                 (~a & ~b) ? 1'b1 : // 00 case
                 1'b0;              // 01 and 10 cases
endmodule