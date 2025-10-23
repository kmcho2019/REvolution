module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    // Generate the carry bits
    wire c0, c1, c2, c3; // Carries for each bit position
    assign c0 = x[0] & y[0];
    assign c1 = (x[1] & y[1]) | (x[1] & c0) | (y[1] & c0);
    assign c2 = (x[2] & y[2]) | (x[2] & c1) | (y[2] & c1);
    assign c3 = (x[3] & y[3]) | (x[3] & c2) | (y[3] & c2);

    // Compute the sum bits using the generated carries
    assign sum[0] = x[0] ^ y[0];
    assign sum[1] = x[1] ^ y[1] ^ c0;
    assign sum[2] = x[2] ^ y[2] ^ c1;
    assign sum[3] = x[3] ^ y[3] ^ c2;
    assign sum[4] = c3; // The final carry bit as the overflow

endmodule