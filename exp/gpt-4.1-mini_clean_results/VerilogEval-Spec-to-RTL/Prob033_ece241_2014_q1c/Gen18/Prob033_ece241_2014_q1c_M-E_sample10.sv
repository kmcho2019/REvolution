module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    // sum = a xor b xor cin
    assign sum = a ^ b ^ cin;
    // cout = majority(a,b,cin)
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] carry;
    // carry[0] is carry in to bit 0
    // carry[8] will be carry out of MSB
    wire carry_in_msb, carry_out_msb;

    assign carry[0] = 1'b0; // initial carry in

    // instantiate 8 full adders in a ripple chain
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : full_adder_chain
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(s[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign carry_in_msb = carry[7];
    assign carry_out_msb = carry[8];

    // Overflow occurs if carry into MSB != carry out of MSB
    assign overflow = carry_in_msb ^ carry_out_msb;

endmodule