module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] c; // carry chain

    assign c[0] = 1'b0; // initial carry-in

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_add
            assign s[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate

    // Overflow: carry into MSB XOR carry out of MSB
    assign overflow = c[7] ^ c[8];

endmodule