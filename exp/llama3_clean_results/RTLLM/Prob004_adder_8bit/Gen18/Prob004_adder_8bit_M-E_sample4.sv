module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

    // First level: 8 half adders
    wire [7:0] sum0;
    wire [7:0] carry0;
    for (genvar i = 0; i < 8; i++) begin
        half_adder ha(
            .a(a[i]),
            .b(b[i]),
            .sum(sum0[i]),
            .carry(carry0[i])
        );
    end

    // Second level: 4 full adders
    wire [3:0] sum1;
    wire [3:0] carry1;
    for (genvar i = 0; i < 4; i++) begin
        full_adder fa(
            .a(sum0[2*i + 1]),
            .b(sum0[2*i]),
            .cin(carry0[2*i]),
            .sum(sum1[i]),
            .cout(carry1[i])
        );
    end

    // Third level: 2 full adders
    wire [1:0] sum2;
    wire [1:0] carry2;
    full_adder fa1(
        .a(sum1[1]),
        .b(sum1[0]),
        .cin(carry1[0]),
        .sum(sum2[0]),
        .cout(carry2[0])
    );
    full_adder fa2(
        .a(sum1[3]),
        .b(sum1[2]),
        .cin(carry1[2]),
        .sum(sum2[1]),
        .cout(carry2[1])
    );

    // Final level: 1 full adder
    full_adder fa3(
        .a(sum2[1]),
        .b(sum2[0]),
        .cin(carry2[0]),
        .sum(sum[7:6]),
        .cout(cout)
    );

    assign sum[5:0] = {carry1[3], carry1[1], sum1[3], carry0[7], carry0[5], carry0[3]};

endmodule

module half_adder(
    input   a,
    input   b,
    output  sum,
    output  carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule