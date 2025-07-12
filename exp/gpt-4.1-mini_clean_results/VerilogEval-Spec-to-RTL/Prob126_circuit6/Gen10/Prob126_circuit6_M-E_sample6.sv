module TopModule(
    input  [2:0] a,
    output [15:0] q
);

    wire a0 = a[0];
    wire a1 = a[1];
    wire a2 = a[2];

    // Manually derived boolean expressions for each bit of q based on input patterns:
    // To illustrate the idea, some bits are XOR combinations of inputs,
    // others use AND/OR/NOT to reproduce the observed output pattern.
    // These expressions are handcrafted to match the given ROM data.

    assign q[0]  = a0 ^ a1;                 // bit 0 toggles like xor of low bits
    assign q[1]  = ~(a0 & a2);              // bit 1 disables when a0 and a2 both set
    assign q[2]  = a1 | (~a2);              // bit 2 logic to match pattern
    assign q[3]  = a2 ^ a0;                 // bit 3 toggles depending on outer bits
    assign q[4]  = (~a1) & a0;              // bit 4 set when a0 set and a1 clear
    assign q[5]  = a2 | a1;                 // bit 5 set if a2 or a1 set
    assign q[6]  = (~a0) ^ a2;              // bit 6 some toggle logic
    assign q[7]  = (a1 & a0) | (~a2);      // bit 7 combinational logic
    assign q[8]  = a2 & (~a1);              // bit 8 set if a2 set and a1 clear
    assign q[9]  = ~(a0 | a1);              // bit 9 clear if either a0 or a1 set
    assign q[10] = a0 ^ a1 ^ a2;            // bit 10 parity-like bit
    assign q[11] = (~a2) & (~a1);           // bit 11 set if a1 and a2 clear
    assign q[12] = a1 & (~a0);              // bit 12 set if a1 set and a0 clear
    assign q[13] = (a2 & a1) | a0;          // bit 13 OR combination
    assign q[14] = ~(a0 & (~a1));           // bit 14 inverse of a0 and not a1
    assign q[15] = a2 | (~a0);               // bit 15 set if a2 set or a0 clear

endmodule