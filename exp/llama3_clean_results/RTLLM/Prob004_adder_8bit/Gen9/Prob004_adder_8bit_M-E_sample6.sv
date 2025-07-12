module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for segmented carry-lookahead adder
wire [3:0] sum_low; // Sum of lower 4 bits
wire [3:0] sum_high; // Sum of higher 4 bits
wire cout_low; // Carry-out of lower 4 bits
wire cout_high; // Carry-out of higher 4 bits

// Lower 4-bit ripple-carry adder
wire c0, c1, c2, c3;
assign c0 = a[0] & b[0];
assign sum_low[0] = a[0] ^ b[0] ^ cin;
assign c1 = a[1] & b[1] | (a[1] & sum_low[0]) | (b[1] & sum_low[0]);
assign sum_low[1] = a[1] ^ b[1] ^ c0;
assign c2 = a[2] & b[2] | (a[2] & sum_low[1]) | (b[2] & sum_low[1]);
assign sum_low[2] = a[2] ^ b[2] ^ c1;
assign c3 = a[3] & b[3] | (a[3] & sum_low[2]) | (b[3] & sum_low[2]);
assign sum_low[3] = a[3] ^ b[3] ^ c2;

// Higher 4-bit ripple-carry adder with carry-in from lower 4 bits
wire c4, c5, c6, c7;
assign c4 = a[4] & b[4];
assign sum_high[0] = a[4] ^ b[4] ^ c3;
assign c5 = a[5] & b[5] | (a[5] & sum_high[0]) | (b[5] & sum_high[0]);
assign sum_high[1] = a[5] ^ b[5] ^ c4;
assign c6 = a[6] & b[6] | (a[6] & sum_high[1]) | (b[6] & sum_high[1]);
assign sum_high[2] = a[6] ^ b[6] ^ c5;
assign c7 = a[7] & b[7] | (a[7] & sum_high[2]) | (b[7] & sum_high[2]);
assign sum_high[3] = a[7] ^ b[7] ^ c6;

// Carry-out computation using carry-lookahead logic
assign cout_low = c3;
assign cout_high = c7 | (sum_high[2] & c6) | (sum_high[1] & c5) | (sum_high[0] & c4);
assign cout = cout_high;

// Final sum computation
assign sum[3:0] = sum_low;
assign sum[7:4] = sum_high;

endmodule