module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    // Directly calculate sum and carry signals for each bit position
    assign sum[0] = x[0] ^ y[0];
    assign sum[1] = x[1] ^ y[1] ^ (x[0] & y[0]);
    assign sum[2] = x[2] ^ y[2] ^ ((x[0] & y[0]) | (x[1] & y[1]) | (x[0] & y[1]) | (x[1] & y[0]));
    assign sum[3] = x[3] ^ y[3] ^ ((x[0] & y[0]) | (x[1] & y[1]) | (x[2] & y[2]) | (x[0] & y[1]) | (x[1] & y[0]) | (x[0] & y[2]) | (x[2] & y[0]) | (x[1] & y[2]) | (x[2] & y[1]));
    assign sum[4] = (x[0] & y[0]) | (x[1] & y[1]) | (x[2] & y[2]) | (x[3] & y[3]) | (x[0] & y[1]) | (x[1] & y[0]) | (x[0] & y[2]) | (x[2] & y[0]) | (x[1] & y[2]) | (x[2] & y[1]) | (x[0] & y[3]) | (x[3] & y[0]) | (x[1] & y[3]) | (x[3] & y[1]) | (x[2] & y[3]) | (x[3] & y[2]);

endmodule