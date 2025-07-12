module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

wire [6:0] c;

// Bit 0
full_adder fa0(a[0], b[0], cin, sum[0], c[0]);

// Bits 1 to 6
generate
    for (genvar i = 1; i <= 6; i++) begin
        full_adder fa(a[i], b[i], c[i-1], sum[i], c[i]);
    end
endgenerate

// Bit 7
full_adder fa7(a[7], b[7], c[6], sum[7], cout);

endmodule

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