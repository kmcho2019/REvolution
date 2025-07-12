module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] carry;  // 9-bit carry chain (includes carry-in and carry-out)
    
    assign carry[0] = 1'b0;  // No carry-in for LSB
    
    // 8-bit ripple-carry adder
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder
            assign s[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    // Overflow occurs if:
    // Both inputs have same sign and result has different sign
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule