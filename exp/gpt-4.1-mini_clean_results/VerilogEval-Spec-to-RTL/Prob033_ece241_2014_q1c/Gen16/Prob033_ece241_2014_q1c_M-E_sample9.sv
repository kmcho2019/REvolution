module FullAdder1Bit (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] carry; // carry[0] = cin, carry[8] = cout from MSB full adder

    assign carry[0] = 1'b0; // initial carry-in

    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin : ADDER_CHAIN
            FullAdder1Bit fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(s[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // overflow = carry into MSB xor carry out of MSB
    assign overflow = carry[7] ^ carry[8];

endmodule