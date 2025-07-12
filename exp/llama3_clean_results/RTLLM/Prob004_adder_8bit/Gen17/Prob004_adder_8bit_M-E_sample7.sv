module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [3:0] sum_lo, sum_hi;
wire c_lo, c_hi;
wire spec_cout;

// 4-bit adder for lower bits
assign {c_lo, sum_lo[3:0]} = a[3:0] + b[3:0] + cin;

// 4-bit adder for upper bits
assign {c_hi, sum_hi[3:0]} = a[7:4] + b[7:4];

// Speculative carry generation
assign spec_cout = (a[3] & b[3]) | (a[3] & c_lo) | (b[3] & c_lo);

// Final addition using speculative carry
assign sum[3:0] = sum_lo[3:0];
assign sum[7:4] = sum_hi[3:0] + {4{spec_cout}};

// Final carry-out
assign cout = c_hi | (spec_cout & c_lo);

endmodule