module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] s;  // Individual sum bits
    wire [4:0] c;  // Carry bits (c[0] is unused)

    assign c[0] = 1'b0;  // Initial carry-in
    
    // Bit 0
    assign s[0] = x[0] ^ y[0] ^ c[0];
    assign c[1] = (x[0] & y[0]) | (x[0] & c[0]) | (y[0] & c[0]);
    
    // Bit 1
    assign s[1] = x[1] ^ y[1] ^ c[1];
    assign c[2] = (x[1] & y[1]) | (x[1] & c[1]) | (y[1] & c[1]);
    
    // Bit 2
    assign s[2] = x[2] ^ y[2] ^ c[2];
    assign c[3] = (x[2] & y[2]) | (x[2] & c[2]) | (y[2] & c[2]);
    
    // Bit 3
    assign s[3] = x[3] ^ y[3] ^ c[3];
    assign c[4] = (x[3] & y[3]) | (x[3] & c[3]) | (y[3] & c[3]);
    
    // Combine outputs
    assign sum = {c[4], s};
endmodule