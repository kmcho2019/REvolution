module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [3:0] x_bits, y_bits;
    wire [3:0] sum_bits;
    wire c0, c1, c2, c3;

    assign x_bits = x;
    assign y_bits = y;

    assign sum[0] = x_bits[0] ^ y_bits[0] ^ 1'b0;
    assign c0 = (x_bits[0] & y_bits[0]) | (x_bits[0] & 1'b0) | (y_bits[0] & 1'b0);

    assign sum[1] = x_bits[1] ^ y_bits[1] ^ c0;
    assign c1 = (x_bits[1] & y_bits[1]) | (x_bits[1] & c0) | (y_bits[1] & c0);

    assign sum[2] = x_bits[2] ^ y_bits[2] ^ c1;
    assign c2 = (x_bits[2] & y_bits[2]) | (x_bits[2] & c1) | (y_bits[2] & c1);

    assign sum[3] = x_bits[3] ^ y_bits[3] ^ c2;
    assign c3 = (x_bits[3] & y_bits[3]) | (x_bits[3] & c2) | (y_bits[3] & c2);

    assign sum[4] = c3;

endmodule