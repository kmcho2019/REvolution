// Define the Ladner-Fischer adder module
module LadnerFischerAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the g and p signals
    wire [7:0] g;
    wire [7:0] p;

    // Compute the g and p signals for each bit position
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];

    assign g[1] = (a[1] & b[1]) | (a[1] & g[0]) | (b[1] & g[0]);
    assign p[1] = (a[1] | b[1]) & (p[0] | g[0]);

    assign g[2] = (a[2] & b[2]) | (a[2] & g[1]) | (b[2] & g[1]);
    assign p[2] = (a[2] | b[2]) & (p[1] | g[1]);

    assign g[3] = (a[3] & b[3]) | (a[3] & g[2]) | (b[3] & g[2]);
    assign p[3] = (a[3] | b[3]) & (p[2] | g[2]);

    assign g[4] = (a[4] & b[4]) | (a[4] & g[3]) | (b[4] & g[3]);
    assign p[4] = (a[4] | b[4]) & (p[3] | g[3]);

    assign g[5] = (a[5] & b[5]) | (a[5] & g[4]) | (b[5] & g[4]);
    assign p[5] = (a[5] | b[5]) & (p[4] | g[4]);

    assign g[6] = (a[6] & b[6]) | (a[6] & g[5]) | (b[6] & g[5]);
    assign p[6] = (a[6] | b[6]) & (p[5] | g[5]);

    assign g[7] = (a[7] & b[7]) | (a[7] & g[6]) | (b[7] & g[6]);
    assign p[7] = (a[7] | b[7]) & (p[6] | g[6]);

    // Compute the sum bits using the g and p signals
    assign sum[0] = a[0] ^ b[0] ^ g[0];
    assign sum[1] = a[1] ^ b[1] ^ g[1];
    assign sum[2] = a[2] ^ b[2] ^ g[2];
    assign sum[3] = a[3] ^ b[3] ^ g[3];
    assign sum[4] = a[4] ^ b[4] ^ g[4];
    assign sum[5] = a[5] ^ b[5] ^ g[5];
    assign sum[6] = a[6] ^ b[6] ^ g[6];
    assign sum[7] = a[7] ^ b[7] ^ g[7];

endmodule

// TopModule that integrates the Ladner-Fischer adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    LadnerFischerAdder adder(
      .a(a),
      .b(b),
      .sum(sum)
    );

    // Overflow detection logic integrated into the TopModule
    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);
    assign s = sum;

endmodule