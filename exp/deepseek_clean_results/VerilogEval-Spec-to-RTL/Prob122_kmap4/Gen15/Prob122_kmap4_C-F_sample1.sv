module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire parity_ab;  // Parity of a and b
    wire parity_cd;  // Parity of c and d
    
    assign parity_ab = a ^ b;
    assign parity_cd = c ^ d;
    assign out = parity_ab ^ parity_cd;  // Final output parity comparison

endmodule