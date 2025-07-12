// Define the full adder module
module full_adder(
    input  clk,  // clock signal for clock gating
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Clock gating: only update the sum and carry-out when the clock is high
    reg sum_reg, cout_reg;
    always @(posedge clk) begin
        sum_reg <= a ^ b ^ cin;
        cout_reg <= (a & b) | (a & cin) | (b & cin);
    end

    assign sum = sum_reg;
    assign cout = cout_reg;

endmodule

// Define the carry-lookahead adder module
module EightBitAdder(
    input  clk,  // clock signal for clock gating
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the carry-lookahead adder
    wire [7:0] g, p;
    wire [8:0] c;

    // Initialize the carry-in for the LSB
    assign c = 1'b0;

    // Calculate the generate and propagate signals
    assign g[0] = a & b[0];
    assign p[0] = a[0] | b[0];
    full_adder fa(
      .clk(clk),
      .a(a[0]),
      .b(b[0]),
      .cin(c[0]),
      .sum(sum[0]),
      .cout(c[1])
    );

    // Calculate the generate and propagate signals for each bit position
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            full_adder fa(
              .clk(clk),
              .a(a[i]),
              .b(b[i]),
              .cin(c[i]),
              .sum(sum[i]),
              .cout(c[i+1])
            );
        end
    endgenerate

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
    input  clk,  // clock signal for clock gating
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    EightBitAdder adder(
      .clk(clk),
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