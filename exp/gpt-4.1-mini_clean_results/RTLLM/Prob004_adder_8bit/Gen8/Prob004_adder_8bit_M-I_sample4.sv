module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Optimized full adder implementation to reduce gate count and switching
    wire axb;
    assign axb  = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,    // Operand A
    input  wire [7:0] b,    // Operand B
    input  wire       cin,  // Carry-in
    output wire [7:0] sum,  // Sum output
    output wire       cout  // Carry-out
);
    wire [8:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_fa
            bit_full_adder fa_inst (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[8];
endmodule