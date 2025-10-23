module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] carry; // carry[0] is carry-in (0), carry[8] is carry-out from MSB
    assign carry[0] = 1'b0; // no initial carry-in

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : ripple_adder
            assign s[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    // Overflow is XOR of carry into MSB and carry out of MSB (bits 7 and 8 in carry vector)
    assign overflow = carry[7] ^ carry[8];

endmodule