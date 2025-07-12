module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] carry; // carry[0] is initial carry-in, carry[8] is final carry-out (not used)
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            // sum bit is xor of inputs and carry in
            assign s[i] = a[i] ^ b[i] ^ carry[i];
            // carry out for next bit
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    // Overflow detected by XOR of carry into MSB (bit 7) and carry out of MSB (bit 7)
    // carry into MSB is carry[7], carry out of MSB is carry[8]
    assign overflow = carry[7] ^ carry[8];

endmodule