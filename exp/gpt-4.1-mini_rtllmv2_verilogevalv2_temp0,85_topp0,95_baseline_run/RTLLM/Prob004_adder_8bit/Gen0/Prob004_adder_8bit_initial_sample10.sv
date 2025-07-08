module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

// 1-bit full adder module
module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

wire [7:0] carry; // internal carry signals

// Instantiate full adders
full_adder fa0 (
    .a   (a[0]),
    .b   (b[0]),
    .cin (cin),
    .sum (sum[0]),
    .cout(carry[0])
);

genvar i;
generate
    for (i = 1; i < 8; i = i + 1) begin : fa_loop
        full_adder fa (
            .a   (a[i]),
            .b   (b[i]),
            .cin (carry[i-1]),
            .sum (sum[i]),
            .cout(carry[i])
        );
    end
endgenerate

assign cout = carry[7];

endmodule