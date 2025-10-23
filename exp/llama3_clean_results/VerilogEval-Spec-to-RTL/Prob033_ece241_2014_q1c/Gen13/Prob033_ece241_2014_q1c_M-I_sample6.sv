// Define the full adder module with optimized logic for lower power consumption
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Calculate the sum and carry-out using optimized logic
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the carry-lookahead adder module
module CLA_Adder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      cout  // carry-out
);

    // Generate and propagate signals
    wire [7:0] g, p;
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];

    for (genvar i = 1; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] ^ b[i];
    end

    // Calculate carry signals
    wire [7:0] c;
    assign c[0] = g[0];
    for (genvar i = 1; i < 8; i++) begin
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end

    // Calculate sum bits
    assign sum[0] = p[0] ^ c[0];
    for (genvar i = 1; i < 8; i++) begin
        assign sum[i] = p[i] ^ c[i];
    end

    // Calculate final carry-out
    assign cout = c[7];

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
    wire cout;

    CLA_Adder adder(
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