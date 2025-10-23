module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Pg,
    output Gg
);
    wire [3:0] G, P;
    wire [3:0] carry;
    
    // Generate and propagate terms
    assign G = a & b;
    assign P = a ^ b;
    
    // Carry calculation
    assign carry[0] = Cin;
    assign carry[1] = G[0] | (P[0] & carry[0]);
    assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & carry[0]);
    assign carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | 
                     (P[2] & P[1] & P[0] & carry[0]);
    
    // Sum and group outputs
    assign y = P ^ carry;
    assign Pg = &P;  // Group propagate
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
               (P[3] & P[2] & P[1] & G[0]);  // Group generate
endmodule

module adder_8bit_cla (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire Pg_lo, Gg_lo, Pg_hi, Gg_hi;
    wire carry_mid;
    
    // Lower 4-bit CLA
    adder_4bit_cla adder_lo (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Pg(Pg_lo),
        .Gg(Gg_lo)
    );
    
    // Upper 4-bit CLA
    adder_4bit_cla adder_hi (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_mid),
        .y(y[7:4]),
        .Pg(Pg_hi),
        .Gg(Gg_hi)
    );
    
    // Inter-block carry
    assign carry_mid = Gg_lo | (Pg_lo & Cin);
    assign Co = Gg_hi | (Pg_hi & Gg_lo) | (Pg_hi & Pg_lo & Cin);
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