// Prefix computation module
module PrefixModule(a, b, p, g);
    input a, b;
    output p, g;
    
    assign p = a ^ b;
    assign g = a & b;
endmodule

// Parallel prefix adder module
module PPA(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // Instantiate prefix computation modules
    wire p0, p1, p2, p3;
    wire g0, g1, g2, g3;
    wire c0, c1, c2, c3, c4;
    
    PrefixModule pm0(x[0], y[0], p0, g0);
    PrefixModule pm1(x[1], y[1], p1, g1);
    PrefixModule pm2(x[2], y[2], p2, g2);
    PrefixModule pm3(x[3], y[3], p3, g3);
    
    // Calculate carry signals
    assign c0 = 1'b0; // Initialize carry for first bit
    assign c1 = g0 | (p0 & c0);
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);
    assign c4 = g3 | (p3 & c3);
    
    // Calculate sum bits
    assign sum[0] = p0 ^ c0;
    assign sum[1] = p1 ^ c1;
    assign sum[2] = p2 ^ c2;
    assign sum[3] = p3 ^ c3;
    assign sum[4] = c4; // Overflow bit
endmodule

// Top-level module
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    PPA ppa(x, y, sum);
endmodule