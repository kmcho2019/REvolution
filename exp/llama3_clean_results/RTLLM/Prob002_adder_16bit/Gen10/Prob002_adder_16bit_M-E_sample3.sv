// 4-bit carry-lookahead adder module
module adder_4bit_cla(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    
    wire [3:0] g; // generate signal
    wire [3:0] p; // propagate signal
    wire [2:0] c; // carry signal
    
    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] | b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] | b[3];
    
    // Calculate carry signal
    assign c[0] = g[0] | (p[0] & Cin);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    
    // Calculate sum signal
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1] ^ c[0];
    assign y[2] = a[2] ^ b[2] ^ c[1];
    assign y[3] = a[3] ^ b[3] ^ c[2];
    
    // Assign output
    assign Co = g[3] | (p[3] & c[2]);
endmodule

// 16-bit hybrid adder module
module hybrid_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C1, C2, C3;
    
    // Instantiate four 4-bit CLA adders
    adder_4bit_cla adder_0(
     .a(a[3:0]),
     .b(b[3:0]),
     .Cin(Cin),
     .y(y[3:0]),
     .Co(C1)
    );
    
    adder_4bit_cla adder_1(
     .a(a[7:4]),
     .b(b[7:4]),
     .Cin(C1),
     .y(y[7:4]),
     .Co(C2)
    );
    
    adder_4bit_cla adder_2(
     .a(a[11:8]),
     .b(b[11:8]),
     .Cin(C2),
     .y(y[11:8]),
     .Co(C3)
    );
    
    adder_4bit_cla adder_3(
     .a(a[15:12]),
     .b(b[15:12]),
     .Cin(C3),
     .y(y[15:12]),
     .Co(Co)
    );
endmodule