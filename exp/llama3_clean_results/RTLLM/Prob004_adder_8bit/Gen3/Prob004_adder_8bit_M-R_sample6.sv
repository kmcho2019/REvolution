// Define a full adder module
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

// Define the 8-bit adder module
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input   cin,
    output  [7:0] sum,
    output  cout
);
    wire [7:0] carry; // Intermediate carry signals

    // Instantiate full adders for each bit position
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Carry-out of the most significant bit is the final carry-out
    assign cout = carry[7];
endmodule