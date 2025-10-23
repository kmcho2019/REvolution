// Improved FullAdder module with simplified logic
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    // Simplified logic for sum and carry-out
    assign {cout, sum} = a + b + cin;
endmodule

// Improved TopModule using a carry-lookahead adder architecture
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // Calculate sum and carry signals directly
    assign sum[0] = x[0] ^ y[0];
    assign sum[1] = x[1] ^ y[1] ^ (x[0] & y[0]);
    assign sum[2] = x[2] ^ y[2] ^ (x[1] & y[1]) ^ (x[0] & y[0] & (x[1] ^ y[1]));
    assign sum[3] = x[3] ^ y[3] ^ (x[2] & y[2]) ^ (x[1] & y[1] & (x[2] ^ y[2])) ^ (x[0] & y[0] & (x[1] ^ y[1]) & (x[2] ^ y[2]));
    assign sum[4] = (x[3] & y[3]) | (x[2] & y[2] & (x[3] ^ y[3])) | (x[1] & y[1] & (x[2] ^ y[2]) & (x[3] ^ y[3])) | (x[0] & y[0] & (x[1] ^ y[1]) & (x[2] ^ y[2]) & (x[3] ^ y[3]));
endmodule