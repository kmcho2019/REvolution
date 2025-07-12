// 1-bit full adder module
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 4-bit carry-lookahead adder module
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    
    wire [3:0] carry;
    wire [3:1] p, g;
    
    // Calculate propagate and generate signals
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];
    
    // Calculate carry signals
    assign carry[0] = Cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    
    // Calculate output bits
    assign y[0] = a[0] ^ b[0] ^ carry[0];
    assign y[1] = a[1] ^ b[1] ^ carry[1];
    assign y[2] = a[2] ^ b[2] ^ carry[2];
    assign y[3] = a[3] ^ b[3] ^ carry[3];
    
    // Calculate carry-out
    assign Co = g[3] | (p[3] & carry[3]);
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire carry1, carry2, carry3;
    
    // Instantiate 4-bit adders
    adder_4bit adder_bit1(
       .a(a[3:0]),
       .b(b[3:0]),
       .Cin(Cin),
       .y(y[3:0]),
       .Co(carry1)
    );
    
    adder_4bit adder_bit2(
       .a(a[7:4]),
       .b(b[7:4]),
       .Cin(carry1),
       .y(y[7:4]),
       .Co(carry2)
    );
    
    adder_4bit adder_bit3(
       .a(a[11:8]),
       .b(b[11:8]),
       .Cin(carry2),
       .y(y[11:8]),
       .Co(carry3)
    );
    
    adder_4bit adder_bit4(
       .a(a[15:12]),
       .b(b[15:12]),
       .Cin(carry3),
       .y(y[15:12]),
       .Co(Co)
    );
endmodule