// Define the carry-lookahead adder module
module carry_lookahead_adder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      carry_out  
);

    // Calculate generate and propagate signals
    wire [7:0] g, p;
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    for (genvar i = 1; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end

    // Calculate carry signals
    wire [7:0] c;
    assign c[0] = a[0] & b[0];
    for (genvar i = 1; i < 8; i++) begin
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end

    // Calculate sum signals
    assign sum[0] = a[0] ^ b[0] ^ c[0];
    for (genvar i = 1; i < 8; i++) begin
        assign sum[i] = a[i] ^ b[i] ^ c[i];
    end

    // Calculate carry out
    assign carry_out = c[7];

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

// TopModule that integrates the carry-lookahead adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;
    wire carry_out;

    carry_lookahead_adder cla_adder(
      .a(a),
      .b(b),
      .sum(sum),
      .carry_out(carry_out)
    );

    OverflowDetector detector(
      .a(a),
      .b(b),
      .sum(sum),
      .overflow(overflow)
    );

    assign s = sum;

endmodule