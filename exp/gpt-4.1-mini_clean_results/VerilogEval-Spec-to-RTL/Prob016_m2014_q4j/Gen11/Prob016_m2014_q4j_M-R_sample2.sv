module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] c; // carry bits between stages

    // bit 0 adder
    assign sum[0] = x[0] ^ y[0];          // sum bit 0 (cin=0)
    assign c[0]   = x[0] & y[0];          // carry out of bit 0

    // bit 1 adder
    assign sum[1] = x[1] ^ y[1] ^ c[0];
    assign c[1]   = (x[1] & y[1]) | (x[1] & c[0]) | (y[1] & c[0]);

    // bit 2 adder
    assign sum[2] = x[2] ^ y[2] ^ c[1];
    assign c[2]   = (x[2] & y[2]) | (x[2] & c[1]) | (y[2] & c[1]);

    // bit 3 adder
    assign sum[3] = x[3] ^ y[3] ^ c[2];
    assign c[3]   = (x[3] & y[3]) | (x[3] & c[2]) | (y[3] & c[2]);

    // overflow bit is the final carry out
    assign sum[4] = c[3];

endmodule