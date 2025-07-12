module multi_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [15:0] product
);

    // Booth encoding - generate partial products
    wire [16:0] pp [0:3]; // 4 partial products (16b + sign)
    
    // Booth encoder
    booth_encoder #(.WIDTH(8)) encoder (
        .multiplicand(A),
        .multiplier(B),
        .pp0(pp[0]),
        .pp1(pp[1]),
        .pp2(pp[2]),
        .pp3(pp[3])
    );

    // Carry-save adder tree
    wire [16:0] sum1, carry1;
    wire [16:0] sum2, carry2;
    
    // First level CSA
    csa #(.WIDTH(17)) csa1 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(sum1),
        .carry(carry1)
    );
    
    // Second level CSA
    csa #(.WIDTH(17)) csa2 (
        .a(sum1),
        .b(carry1),
        .c(pp[3]),
        .sum(sum2),
        .carry(carry2)
    );
    
    // Final adder
    assign product = sum2 + carry2;

endmodule

module booth_encoder #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] multiplicand,
    input wire [WIDTH-1:0] multiplier,
    output wire [WIDTH:0] pp0,
    output wire [WIDTH:0] pp1,
    output wire [WIDTH:0] pp2,
    output wire [WIDTH:0] pp3
);
    // Booth encoding logic here
    // Generates 4 partial products from 8-bit inputs
    // Implementation details omitted for brevity
endmodule

module csa #(parameter WIDTH = 17) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire [WIDTH-1:0] c,
    output wire [WIDTH-1:0] sum,
    output wire [WIDTH-1:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = {a[WIDTH-2:0] & b[WIDTH-2:0] | 
                  a[WIDTH-2:0] & c[WIDTH-2:0] | 
                  b[WIDTH-2:0] & c[WIDTH-2:0], 1'b0};
endmodule