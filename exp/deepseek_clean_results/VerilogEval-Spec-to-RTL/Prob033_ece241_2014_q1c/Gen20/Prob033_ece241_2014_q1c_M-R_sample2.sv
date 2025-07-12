module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    wire [7:0] c;

    // Carry chain using generate-for
    assign c[0] = g[0];
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : carry_chain
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Overflow detection
    assign overflow = c[7] ^ c[6];
endmodule