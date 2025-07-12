// Define the carry-lookahead adder module
module EightBitAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the carry-lookahead adder
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
        for (i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    EightBitAdder adder(
      .a(a),
      .b(b),
      .sum(sum)
    );

    // Overflow detection logic integrated into the TopModule
    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);
    assign s = sum;

endmodule