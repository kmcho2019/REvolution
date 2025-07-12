// Define the Kogge-Stone adder module
module KoggeStoneAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      overflow  
);

    // Internal wires for the generate and propagate signals
    wire [7:0] g, p;

    // Generate and propagate signals
    assign g = a & b;
    assign p = a | b;

    // Calculate the carry signals using the Kogge-Stone adder logic
    wire c0, c1, c2, c3, c4, c5, c6, c7;
    assign c0 = g[0];
    assign c1 = g[1] | (p[1] & c0);
    assign c2 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & c0);
    assign c3 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & c0);
    assign c4 = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & c0);
    assign c5 = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & c0);
    assign c6 = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) | (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & c0);
    assign c7 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) | (p[7] & p[6] & p[5] & p[4] & g[3]) | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & c0);

    // Calculate the sum signals
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;

    // Integrated overflow detection
    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the Kogge-Stone adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    KoggeStoneAdder adder(
      .a(a),
      .b(b),
      .sum(s),
      .overflow(overflow)
    );

endmodule