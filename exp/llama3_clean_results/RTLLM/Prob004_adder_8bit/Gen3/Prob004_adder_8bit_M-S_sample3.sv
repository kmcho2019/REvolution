module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [6:0] c;

    full_adder fa0(a[0], b[0], cin, sum[0], c[0]);
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            full_adder fa_(a[i], b[i], c[i-1], sum[i], c[i]);
        end
    endgenerate

    assign cout = c[6];

endmodule