module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] carry; // carry[0] = initial carry in = 0, carry[8] = carry out of MSB
    wire [7:0] sum;

    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            assign s[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    // Overflow = carry into MSB ^ carry out of MSB = carry[7] ^ carry[8]
    assign overflow = carry[7] ^ carry[8];

endmodule