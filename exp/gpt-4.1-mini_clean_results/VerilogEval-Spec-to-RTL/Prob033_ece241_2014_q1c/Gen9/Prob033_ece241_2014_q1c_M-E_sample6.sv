module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] carry;

    // First bit adder: carry-in = 0
    FullAdder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(1'b0),
        .sum(s[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for(i = 1; i < 8; i = i + 1) begin : adder_chain
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(s[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Overflow: XOR of carry into MSB and carry out from MSB
    assign overflow = carry[6] ^ carry[7];

endmodule