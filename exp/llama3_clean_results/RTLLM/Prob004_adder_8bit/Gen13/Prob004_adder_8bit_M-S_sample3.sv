module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire [7:0] c;

// Calculate carry signals and sum starting from LSB
assign sum[0] = a[0] ^ b[0] ^ cin;
assign c[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

// Cascade full adders for each bit position
generate
    for (genvar i = 1; i < 8; i++) begin
        assign sum[i] = a[i] ^ b[i] ^ c[i-1];
        assign c[i] = (a[i] & b[i]) | (a[i] & c[i-1]) | (b[i] & c[i-1]);
    end
endgenerate

// Carry-out is the carry from the MSB full adder
assign cout = c[7];

endmodule