module TopModule (
    input  a,    // Unused input
    input  b,    // Primary input 1
    input  c,    // Primary input 2
    input  d,    // Unused input
    output q     // Output = b OR c
);
    // Combinational logic: OR operation between b and c
    assign q = b | c;
endmodule