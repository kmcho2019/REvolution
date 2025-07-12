module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Lower 4-bit adder
wire [3:0] sum_lower;
wire       cout_lower;
adder_4bit lower_adder(
    .a(a[3:0]),
    .b(b[3:0]),
    .cin(cin),
    .sum(sum_lower),
    .cout(cout_lower)
);

// Upper 4-bit adder
wire [3:0] sum_upper;
wire       cout_upper;
adder_4bit upper_adder(
    .a(a[7:4]),
    .b(b[7:4]),
    .cin(cout_lower),
    .sum(sum_upper),
    .cout(cout_upper)
);

// Speculative carry generation
wire       spec_cout;
assign spec_cout = (a[3] & b[3]) | (a[3] & cout) | (b[3] & cout);

// Combine results using multiplexers
assign sum[3:0] = sum_lower;
assign sum[7:4] = (cout_lower == spec_cout) ? sum_upper : sum_upper + 1;

// Calculate carry-out
assign cout = cout_upper;

endmodule

// 4-bit adder module
module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);

wire [3:1] c;
assign c[1] = a[0] & b[0] | (a[0] & cin) | (b[0] & cin);
assign sum[0] = a[0] ^ b[0] ^ cin;

genvar i;
generate
    for (i = 1; i < 4; i++) begin
        assign c[i] = a[i] & b[i] | (a[i] & c[i-1]) | (b[i] & c[i-1]);
        assign sum[i] = a[i] ^ b[i] ^ c[i-1];
    end
endgenerate

assign cout = c[3];

endmodule