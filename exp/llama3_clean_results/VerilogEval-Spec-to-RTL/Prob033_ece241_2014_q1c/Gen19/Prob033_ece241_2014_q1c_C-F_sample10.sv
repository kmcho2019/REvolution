// Define the full adder module
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Calculate the sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the hybrid adder module
module HybridAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the hybrid adder
    wire [7:0] g, p;
    wire [8:0] c;

    // Initialize the carry-in for the LSB
    assign c[0] = 1'b0;

    // Calculate the generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign sum[0] = a[0] ^ b[0] ^ c[0];
    assign c[1] = g[0] | (p[0] & c[0]);

    // Calculate the generate and propagate signals for each bit position
    genvar i;
    generate
        for (i = 1; i < 4; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Use carry-lookahead for the most significant bits
    assign sum[4] = a[4] ^ b[4] ^ c[4];
    assign sum[5] = a[5] ^ b[5] ^ c[5];
    assign sum[6] = a[6] ^ b[6] ^ c[6];
    assign sum[7] = a[7] ^ b[7] ^ c[7];

endmodule

// Define the pipelined adder module
module PipelinedAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    reg [7:0] sum_reg;

    HybridAdder adder(
     .a(a),
     .b(b),
     .sum(sum_reg)
    );

    assign sum = sum_reg;

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    PipelinedAdder adder(
     .a(a),
     .b(b),
     .sum(sum)
    );

    OverflowDetector detector(
     .a(a),
     .b(b),
     .sum(sum),
     .overflow(overflow)
    );

    assign s = sum;

endmodule