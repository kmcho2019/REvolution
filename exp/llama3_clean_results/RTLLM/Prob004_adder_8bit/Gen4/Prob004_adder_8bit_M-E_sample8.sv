module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input   cin,
    output  [7:0] sum,
    output  cout
);

    // Divide the operands into four 2-bit segments
    wire [1:0] a0, a1, a2, a3;
    wire [1:0] b0, b1, b2, b3;
    assign a0 = a[1:0];
    assign a1 = a[3:2];
    assign a2 = a[5:4];
    assign a3 = a[7:6];
    assign b0 = b[1:0];
    assign b1 = b[3:2];
    assign b2 = b[5:4];
    assign b3 = b[7:6];

    // First level of addition using half-adders
    wire [1:0] sum0, sum1, sum2, sum3;
    wire cout0, cout1, cout2, cout3;
    half_adder ha0(a0, b0, sum0, cout0);
    half_adder ha1(a1, b1, sum1, cout1);
    half_adder ha2(a2, b2, sum2, cout2);
    half_adder ha3(a3, b3, sum3, cout3);

    // Second level of addition using full adders
    wire [2:0] sum01, sum23;
    wire cout01, cout23;
    full_adder fa01(sum0, sum1, cout0 | cout1, sum01, cout01);
    full_adder fa23(sum2, sum3, cout2 | cout3, sum23, cout23);

    // Final addition using a full adder
    wire [3:0] final_sum;
    wire final_cout;
    full_adder fa_final(sum01, sum23, cout01 | cout23, final_sum, final_cout);

    // Adjust the final sum and carry-out
    assign sum = {final_sum[2:0], cin};
    assign cout = final_cout;

endmodule

// Half-adder module
module half_adder(
    input   [1:0] a,
    input   [1:0] b,
    output  [1:0] sum,
    output  cout
);
    assign sum = a ^ b;
    assign cout = (a[0] & b[0]) | (a[1] & b[1]);
endmodule

// Full-adder module
module full_adder(
    input   [1:0] a,
    input   [1:0] b,
    input   cin,
    output  [2:0] sum,
    output  cout
);
    assign sum = a + b + cin;
    assign cout = (a[1] & b[1]) | (a[0] & b[0]) | (cin & (a[0] | b[0]));
endmodule