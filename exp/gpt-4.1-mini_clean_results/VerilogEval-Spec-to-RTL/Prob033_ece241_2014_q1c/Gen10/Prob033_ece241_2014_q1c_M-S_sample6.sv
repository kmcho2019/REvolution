module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] carry;
    assign carry[0] = 1'b0;  // initial carry-in

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            assign s[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    // Overflow = carry into MSB ^ carry out of MSB
    assign overflow = carry[7] ^ carry[8];

endmodule