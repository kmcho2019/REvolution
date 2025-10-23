module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Pg,
    output Gg
);
    wire [3:0] G, P;
    wire [4:0] C;
    
    // Generate and Propagate
    assign G = a & b;
    assign P = a ^ b;
    
    // Carry Lookahead Logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & C[0]);
    
    // Sum and Group Signals
    assign y = P ^ C[3:0];
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_8bit_cla (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [1:0] Pg, Gg;
    wire C_mid;
    
    // Lower 4-bit CLA
    adder_4bit_cla low (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Pg(Pg[0]),
        .Gg(Gg[0])
    );
    
    // Upper 4-bit CLA
    adder_4bit_cla high (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C_mid),
        .y(y[7:4]),
        .Pg(Pg[1]),
        .Gg(Gg[1])
    );
    
    // Block Carry Lookahead
    assign C_mid = Gg[0] | (Pg[0] & Cin);
    assign Co = Gg[1] | (Pg[1] & Gg[0]) | (Pg[1] & Pg[0] & Cin);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    // Lower 8-bit CLA adder
    adder_8bit_cla adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    // Upper 8-bit CLA adder
    adder_8bit_cla adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule