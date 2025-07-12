// Define the full adder module with optimized logic
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Calculate the sum and carry-out with optimized logic
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the 8-bit carry-lookahead adder module for better performance
module EightBitAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      cout  // carry-out
);

    // Internal wires for the carry-lookahead adder
    wire [7:0] p;  // propagate
    wire [7:0] g;  // generate
    wire [7:1] c;  // carry

    // Initialize the carry-in for the LSB
    assign c[0] = 1'b0;

    // Calculate propagate and generate signals
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    for (genvar i = 1; i < 8; i++) begin
        assign p[i] = a[i] ^ b[i];
        assign g[i] = a[i] & b[i];
    end

    // Calculate carry signals using carry-lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    for (genvar i = 2; i < 8; i++) begin
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
    assign cout = g[7] | (p[7] & c[7]);

    // Calculate sum bits
    assign sum[0] = p[0] ^ c[0];
    for (genvar i = 1; i < 8; i++) begin
        assign sum[i] = p[i] ^ c[i];
    end

endmodule

// Define the overflow detection module with optimized logic
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
    wire cout;

    EightBitAdder adder(
      .a(a),
      .b(b),
      .sum(sum),
      .cout(cout)
    );

    OverflowDetector detector(
      .a(a),
      .b(b),
      .sum(sum),
      .overflow(overflow)
    );

    assign s = sum;

endmodule