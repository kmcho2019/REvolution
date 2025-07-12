module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire [16:0] carry;  // carry[0] = Cin, carry[16] = Co
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bit_adder
            // Sum bit: y[i] = a[i] XOR b[i] XOR carry[i]
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            // Carry out: carry[i+1] = majority(a[i], b[i], carry[i])
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign Co = carry[16];
endmodule