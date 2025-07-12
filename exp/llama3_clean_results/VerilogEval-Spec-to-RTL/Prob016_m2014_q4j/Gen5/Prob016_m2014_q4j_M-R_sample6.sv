// TopModule refactored to directly implement the 4-bit adder
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire carry1, carry2, carry3;
    
    // Compute the sum and carry for each bit position
    assign sum[0] = x[0] ^ y[0];
    assign carry1 = x[0] & y[0];
    assign sum[1] = x[1] ^ y[1] ^ carry1;
    assign carry2 = (x[1] & y[1]) | (x[1] & carry1) | (y[1] & carry1);
    assign sum[2] = x[2] ^ y[2] ^ carry2;
    assign carry3 = (x[2] & y[2]) | (x[2] & carry2) | (y[2] & carry2);
    assign sum[3] = x[3] ^ y[3] ^ carry3;
    assign sum[4] = (x[3] & y[3]) | (x[3] & carry3) | (y[3] & carry3);
endmodule