// Define the full adder module for ripple-carry adder
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

// Define the carry-lookahead adder module
module FourBitCLA(
    input  [3:0] a,  
    input  [3:0] b,  
    output [3:0] sum,  
    output cout  
);

    // Internal wires for the carry-lookahead adder
    wire [3:0] g, p;
    wire [4:0] c;

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

endmodule

// Define the hybrid adder module
module HybridAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      overflow  
);

    wire [3:0] sum_lower;
    wire cout_lower;
    wire [3:0] sum_upper;
    wire cout_upper;

    // Ripple-carry adder for lower bits
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(1'b0),
        .sum(sum_lower[0]),
        .cout(cout_lower)
    );

    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(cout_lower),
        .sum(sum_lower[1]),
        .cout()
    );

    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(),
        .sum(sum_lower[2]),
        .cout()
    );

    full_adder fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(),
        .sum(sum_lower[3]),
        .cout(cout_lower)
    );

    // Carry-lookahead adder for upper bits
    FourBitCLA cla(
        .a(a[7:4]),
        .b(b[7:4]),
        .sum(sum_upper),
        .cout(cout_upper)
    );

    // Assign outputs
    assign sum[3:0] = sum_lower;
    assign sum[7:4] = sum_upper;

    // Integrated overflow detection
    assign overflow = (a[7] == b[7] && a[7] != sum[7]);

endmodule

// TopModule that integrates the hybrid adder
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    HybridAdder adder(
        .a(a),
        .b(b),
        .sum(s),
        .overflow(overflow)
    );

endmodule