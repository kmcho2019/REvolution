module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Generate and propagate terms for optimized carry calculation
    wire [7:0] g = a & b;  // Generate terms
    wire [7:0] p = a | b;  // Propagate terms
    wire [8:0] c;          // Carry chain
    
    assign c[0] = cin;
    
    // Optimized carry chain using generate/propagate terms
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_chain
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate
    
    // Compact sum calculation using XOR
    assign sum = a ^ b ^ c[7:0];
    assign cout = c[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;

    // Lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );

    // Upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule