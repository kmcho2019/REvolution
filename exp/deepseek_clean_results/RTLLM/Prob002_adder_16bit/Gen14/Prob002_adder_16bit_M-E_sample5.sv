module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output p_group
);
    wire [3:0] p, g;
    wire [4:0] c;
    
    assign p = a ^ b;       // Propagate
    assign g = a & b;       // Generate
    assign p_group = &p;    // Group propagate
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    
    assign sum = p ^ c[3:0];
    assign cout = c[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] cout;
    wire [3:0] p_group;
    wire [3:0] carry;
    
    // First 4-bit adder (no skip possible)
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(cout[0]),
        .p_group(p_group[0])
    );
    
    // Middle adders with carry-skip logic
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : adders
            assign carry[i] = p_group[i-1] ? carry[i-1] : cout[i-1];
            
            adder_4bit adder (
                .a(a[4*i+3 : 4*i]),
                .b(b[4*i+3 : 4*i]),
                .cin(carry[i]),
                .sum(y[4*i+3 : 4*i]),
                .cout(cout[i]),
                .p_group(p_group[i])
            );
        end
    endgenerate
    
    assign Co = p_group[3] ? carry[3] : cout[3];
endmodule