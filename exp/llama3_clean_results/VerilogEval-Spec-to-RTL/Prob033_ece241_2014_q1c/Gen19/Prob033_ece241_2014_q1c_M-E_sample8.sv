// Define the ripple-carry adder module
module RippleCarryAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the ripple-carry adder
    wire [7:0] carry;

    // Initialize the carry-in for the LSB
    assign carry[0] = 1'b0;

    // Calculate the sum and carry-out for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            if (i == 0) begin
                assign sum[i] = a[i] ^ b[i] ^ carry[i];
                assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
            end else begin
                assign sum[i] = a[i] ^ b[i] ^ carry[i];
                assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
            end
        end
    endgenerate

endmodule

// Define the Booth multiplier-based adder module
module BoothMultiplierAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the Booth multiplier
    wire [7:0] p, g;
    wire [8:0] c;

    // Initialize the carry-in for the LSB
    assign c[0] = 1'b0;

    // Calculate the partial products
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
        end
    endgenerate

    // Calculate the sum using the ripple-carry adder
    RippleCarryAdder adder(
     .a(p),
     .b(g),
     .sum(sum)
    );

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

// TopModule that integrates the Booth multiplier-based adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    BoothMultiplierAdder adder(
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