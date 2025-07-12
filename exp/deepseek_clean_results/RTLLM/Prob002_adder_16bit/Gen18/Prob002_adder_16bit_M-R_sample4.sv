module adder_16bit #(
    parameter WIDTH = 16
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input Cin,
    output [WIDTH-1:0] y,
    output Co
);
    // Generate and propagate terms
    wire [WIDTH-1:0] g = a & b;
    wire [WIDTH-1:0] p = a | b;
    
    // Carry chain calculation
    wire [WIDTH:0] c;
    assign c[0] = Cin;
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : carry_chain
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate
    
    // Sum calculation
    assign y = a ^ b ^ c[WIDTH-1:0];
    assign Co = c[WIDTH];
endmodule