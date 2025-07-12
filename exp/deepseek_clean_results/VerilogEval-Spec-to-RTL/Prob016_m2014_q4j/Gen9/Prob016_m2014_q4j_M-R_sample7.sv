module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] s;      // Individual sum bits
    wire [3:0] c;      // Carry bits (c[3] is final carry-out)

    // Bit 0 (LSB)
    assign s[0] = x[0] ^ y[0];
    assign c[0] = x[0] & y[0];
    assign sum[0] = s[0];  // No carry-in for LSB

    // Bit 1
    assign s[1] = x[1] ^ y[1] ^ c[0];
    assign c[1] = (x[1] & y[1]) | (x[1] & c[0]) | (y[1] & c[0]);
    assign sum[1] = s[1];

    // Bit 2
    assign s[2] = x[2] ^ y[2] ^ c[1];
    assign c[2] = (x[2] & y[2]) | (x[2] & c[1]) | (y[2] & c[1]);
    assign sum[2] = s[2];

    // Bit 3 (MSB)
    assign s[3] = x[3] ^ y[3] ^ c[2];
    assign c[3] = (x[3] & y[3]) | (x[3] & c[2]) | (y[3] & c[2]);
    assign sum[3] = s[3];

    // Overflow bit
    assign sum[4] = c[3];
endmodule