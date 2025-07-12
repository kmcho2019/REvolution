module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [3:0] sum_low, sum_high;
wire c_low, c_high, c_out;

// Lower 4-bit adder
assign sum_low[0] = a[0] ^ b[0] ^ cin;
assign sum_low[1] = a[1] ^ b[1] ^ (a[0] & b[0] | (a[0] | b[0]) & cin);
assign sum_low[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin));
assign sum_low[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin)));

// Carry-out for lower 4-bit adder
assign c_low = (a[0] & b[0]) | ((a[0] | b[0]) & cin) |
               ((a[1] & b[1]) & (a[0] | b[0] | cin)) |
               ((a[2] & b[2]) & ((a[0] | b[0] | cin) | (a[1] & b[1]))) |
               ((a[3] & b[3]) & (((a[0] | b[0] | cin) | (a[1] & b[1])) | (a[2] & b[2])));

// Higher 4-bit adder
assign sum_high[0] = a[4] ^ b[4] ^ c_low;
assign sum_high[1] = a[5] ^ b[5] ^ (a[4] & b[4] | (a[4] | b[4]) & c_low);
assign sum_high[2] = a[6] ^ b[6] ^ (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & c_low));
assign sum_high[3] = a[7] ^ b[7] ^ (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & c_low)));

// Carry-out for higher 4-bit adder
assign c_high = (a[4] & b[4]) | ((a[4] | b[4]) & c_low) |
               ((a[5] & b[5]) & (a[4] | b[4] | c_low)) |
               ((a[6] & b[6]) & ((a[4] | b[4] | c_low) | (a[5] & b[5]))) |
               ((a[7] & b[7]) & (((a[4] | b[4] | c_low) | (a[5] & b[5])) | (a[6] & b[6])));

// Carry-out of the 8-bit adder
assign cout = c_high;

// Final sum
assign sum[3:0] = sum_low;
assign sum[7:4] = sum_high;

endmodule