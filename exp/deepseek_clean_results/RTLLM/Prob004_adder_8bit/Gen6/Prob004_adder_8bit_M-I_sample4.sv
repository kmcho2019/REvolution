module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] g, p;
    wire [8:0] c;
    
    assign c[0] = cin;
    
    // Generate and propagate terms
    assign g = a & b;  // Generate
    assign p = a ^ b;  // Propagate
    
    // Carry computation
    assign c[8:1] = g | (p & c[7:0]);
    
    // Sum computation
    assign sum = p ^ c[7:0];
    
    assign cout = c[8];

endmodule