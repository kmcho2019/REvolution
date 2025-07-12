module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Split the inputs into lower and upper 4 bits
    wire [3:0] a_lo = a[3:0];
    wire [3:0] a_hi = a[7:4];
    wire [3:0] b_lo = b[3:0];
    wire [3:0] b_hi = b[7:4];

    // 4-bit Ripple Carry Adders for lower and upper bits
    wire [3:0] sum_lo;
    wire cout_lo;
    wire [3:0] sum_hi;
    wire cout_hi;

    // Carry Lookahead Adder for final result
    wire [3:0] sum_cla;
    wire cout_cla;

    // RCA for lower 4 bits
    assign sum_lo[0] = a_lo[0] ^ b_lo[0] ^ cin;
    assign cout_lo = (a_lo[0] & b_lo[0]) | (a_lo[0] & cin) | (b_lo[0] & cin);
    assign sum_lo[1] = a_lo[1] ^ b_lo[1] ^ cout_lo;
    assign cout_lo = (a_lo[1] & b_lo[1]) | (a_lo[1] & cout_lo) | (b_lo[1] & cout_lo);
    assign sum_lo[2] = a_lo[2] ^ b_lo[2] ^ cout_lo;
    assign cout_lo = (a_lo[2] & b_lo[2]) | (a_lo[2] & cout_lo) | (b_lo[2] & cout_lo);
    assign sum_lo[3] = a_lo[3] ^ b_lo[3] ^ cout_lo;
    assign cout_lo = (a_lo[3] & b_lo[3]) | (a_lo[3] & cout_lo) | (b_lo[3] & cout_lo);

    // RCA for upper 4 bits
    assign sum_hi[0] = a_hi[0] ^ b_hi[0] ^ cout_lo;
    assign cout_hi = (a_hi[0] & b_hi[0]) | (a_hi[0] & cout_lo) | (b_hi[0] & cout_lo);
    assign sum_hi[1] = a_hi[1] ^ b_hi[1] ^ cout_hi;
    assign cout_hi = (a_hi[1] & b_hi[1]) | (a_hi[1] & cout_hi) | (b_hi[1] & cout_hi);
    assign sum_hi[2] = a_hi[2] ^ b_hi[2] ^ cout_hi;
    assign cout_hi = (a_hi[2] & b_hi[2]) | (a_hi[2] & cout_hi) | (b_hi[2] & cout_hi);
    assign sum_hi[3] = a_hi[3] ^ b_hi[3] ^ cout_hi;
    assign cout_hi = (a_hi[3] & b_hi[3]) | (a_hi[3] & cout_hi) | (b_hi[3] & cout_hi);

    // CLA for final result
    assign sum_cla[0] = sum_lo[0] ^ sum_hi[0] ^ cin;
    assign cout_cla = (sum_lo[0] & sum_hi[0]) | (sum_lo[0] & cin) | (sum_hi[0] & cin);
    assign sum_cla[1] = sum_lo[1] ^ sum_hi[1] ^ cout_cla;
    assign cout_cla = (sum_lo[1] & sum_hi[1]) | (sum_lo[1] & cout_cla) | (sum_hi[1] & cout_cla);
    assign sum_cla[2] = sum_lo[2] ^ sum_hi[2] ^ cout_cla;
    assign cout_cla = (sum_lo[2] & sum_hi[2]) | (sum_lo[2] & cout_cla) | (sum_hi[2] & cout_cla);
    assign sum_cla[3] = sum_lo[3] ^ sum_hi[3] ^ cout_cla;
    assign cout_cla = (sum_lo[3] & sum_hi[3]) | (sum_lo[3] & cout_cla) | (sum_hi[3] & cout_cla);

    // Final output
    assign sum[3:0] = sum_lo;
    assign sum[7:4] = sum_hi;
    assign cout = cout_cla;

endmodule