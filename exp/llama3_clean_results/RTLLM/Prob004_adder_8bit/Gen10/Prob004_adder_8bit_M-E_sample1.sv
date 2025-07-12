module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for 2-bit adder results
wire [2:0] sum0, sum1, sum2, sum3;
wire c0, c1, c2, c3; // Carry-outs from 2-bit adders

// 2-bit adders for each segment
assign sum0 = {1'b0, a[1:0]} + {1'b0, b[1:0]} + {3{cin}};
assign sum1 = {1'b0, a[3:2]} + {1'b0, b[3:2]} + {3{c0}};
assign sum2 = {1'b0, a[5:4]} + {1'b0, b[5:4]} + {3{c1}};
assign sum3 = {1'b0, a[7:6]} + {1'b0, b[7:6]} + {3{c2}};

// Carry-outs from 2-bit adders
assign c0 = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
assign c1 = (a[2] & b[2]) | (a[2] & c0) | (b[2] & c0);
assign c2 = (a[4] & b[4]) | (a[4] & c1) | (b[4] & c1);
assign c3 = (a[6] & b[6]) | (a[6] & c2) | (b[6] & c2);

// Final carry-out
assign cout = c3;

// Combine 3-bit sums using 4-bit adders
assign sum[1:0] = sum0[1:0];
assign sum[3:2] = sum1[1:0] + {2{c0}};
assign sum[5:4] = sum2[1:0] + {2{c1}};
assign sum[7:6] = sum3[1:0] + {2{c2}};

endmodule