module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    wire [7:0] carry;

    // Full adder module definition
    module full_adder(
        input  a,
        input  b,
        input  cin,
        output sum,
        output cout
    );
        assign {cout, sum} = a + b + cin;
    endmodule

    // Instantiate 8 full adders in a generate loop
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adders
            if (i == 0) begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[7];

endmodule