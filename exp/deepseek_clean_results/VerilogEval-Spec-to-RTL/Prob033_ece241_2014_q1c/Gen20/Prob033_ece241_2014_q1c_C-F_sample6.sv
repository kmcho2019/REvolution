module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    parameter WIDTH = 8;
    
    wire [WIDTH-1:0] g = a & b;
    wire [WIDTH-1:0] p = a ^ b;
    wire [WIDTH-1:0] c;

    // Efficient ripple-carry chain using generate
    genvar i;
    assign c[0] = g[0];
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : carry_chain
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate
    
    // Sum computation (propagate XOR carry-in)
    assign s = p ^ {c[WIDTH-2:0], 1'b0};
    
    // Signed overflow occurs when carry into MSB != carry out of MSB
    assign overflow = c[WIDTH-1] ^ c[WIDTH-2];
endmodule