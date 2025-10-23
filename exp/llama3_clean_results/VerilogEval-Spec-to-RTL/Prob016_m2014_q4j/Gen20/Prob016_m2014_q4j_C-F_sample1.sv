// Optimized FullAdder module with reduced logic for power and area
module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    
    // Simplified logic for sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// TopModule with optimized carry-lookahead adder architecture
module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);
    
    // Directly calculate carry signals and sum bits
    assign sum[0] = x[0] ^ y[0];
    assign sum[1] = x[1] ^ y[1] ^ (x[0] & y[0]);
    assign sum[2] = x[2] ^ y[2] ^ ((x[1] & y[1]) | (x[1] & (x[0] & y[0])) | (y[1] & (x[0] & y[0])));
    assign sum[3] = x[3] ^ y[3] ^ ((x[2] & y[2]) | (x[2] & ((x[1] & y[1]) | (x[1] & (x[0] & y[0])) | (y[1] & (x[0] & y[0])))) | (y[2] & ((x[1] & y[1]) | (x[1] & (x[0] & y[0])) | (y[1] & (x[0] & y[0])))));
    assign sum[4] = (x[3] & y[3]) | (x[3] & ((x[2] & y[2]) | (x[2] & ((x[1] & y[1]) | (x[1] & (x[0] & y[0])) | (y[1] & (x[0] & y[0])))) | (y[2] & ((x[1] & y[1]) | (x[1] & (x[0] & y[0])) | (y[1] & (x[0] & y[0])))))) | (y[3] & ((x[2] & y[2]) | (x[2] & ((x[1] & y[1]) | (x[1] & (x[0] & y[0])) | (y[1] & (x[0] & y[0])))) | (y[2] & ((x[1] & y[1]) | (x[1] & (x[0] & y[0])) | (y[1] & (x[0] & y[0]))))));
endmodule