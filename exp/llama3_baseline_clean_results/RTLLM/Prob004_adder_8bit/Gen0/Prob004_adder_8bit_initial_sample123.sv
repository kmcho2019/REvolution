module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [6:0] carry;

    // Full adder for bit position 0
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);

    // Full adders for bit positions 1 to 6
    generate
        for (genvar i = 1; i < 7; i++) begin
            full_adder fa_i(a[i], b[i], carry[i-1], sum[i], carry[i]);
        end
    endgenerate

    // Full adder for bit position 7
    full_adder fa7(a[7], b[7], carry[6], sum[7], cout);

endmodule

// Full adder module
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