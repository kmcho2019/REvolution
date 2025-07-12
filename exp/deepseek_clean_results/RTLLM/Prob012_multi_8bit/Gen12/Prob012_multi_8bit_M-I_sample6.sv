module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Booth encoding to reduce partial products
    wire [8:0] booth_pp [3:0];
    wire [15:0] pp [3:0];
    
    // Booth encoder
    booth_encoder #(.WIDTH(8)) encoder (
        .A(A),
        .B(B),
        .pp0(booth_pp[0]),
        .pp1(booth_pp[1]),
        .pp2(booth_pp[2]),
        .pp3(booth_pp[3])
    );
    
    // Sign extend and shift partial products
    assign pp[0] = {{7{booth_pp[0][8]}}, booth_pp[0]};
    assign pp[1] = {{5{booth_pp[1][8]}}, booth_pp[1], 2'b0};
    assign pp[2] = {{3{booth_pp[2][8]}}, booth_pp[2], 4'b0};
    assign pp[3] = {{1{booth_pp[3][8]}}, booth_pp[3], 6'b0};

    // First level compression (4:2 compressor)
    wire [15:0] sum1, carry1, cout1;
    compressor_4to2 comp1 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .d(pp[3]),
        .cin(1'b0),
        .sum(sum1),
        .carry(carry1),
        .cout(cout1)
    );

    // Second level compression (3:2 CSA)
    wire [15:0] sum2, carry2;
    csa csa_level2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c({15'b0, cout1}),
        .sum(sum2),
        .carry(carry2)
    );

    // Final addition using hybrid adder (Kogge-Stone for upper bits, RCA for lower)
    hybrid_adder final_adder (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .sum(product)
    );

endmodule

// Booth Encoder Module (Radix-4)
module booth_encoder #(parameter WIDTH = 8) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output reg [WIDTH:0] pp0,
    output reg [WIDTH:0] pp1,
    output reg [WIDTH:0] pp2,
    output reg [WIDTH:0] pp3
);
    // Booth recoding
    always @(*) begin
        // Group bits in overlapping triplets
        // PP0 (bits 1:0 with implicit -1 bit)
        case ({B[1], B[0], 1'b0})
            3'b000, 3'b111: pp0 = 9'b0;
            3'b001, 3'b010: pp0 = {A[7], A};
            3'b011: pp0 = {A, 1'b0};
            3'b100: pp0 = ~{A, 1'b0} + 1'b1;
            3'b101, 3'b110: pp0 = ~{A[7], A} + 1'b1;
        endcase
        
        // PP1 (bits 3:1)
        case (B[3:1])
            3'b000, 3'b111: pp1 = 9'b0;
            3'b001, 3'b010: pp1 = {A[7], A};
            3'b011: pp1 = {A, 1'b0};
            3'b100: pp1 = ~{A, 1'b0} + 1'b1;
            3'b101, 3'b110: pp1 = ~{A[7], A} + 1'b1;
        endcase
        
        // PP2 (bits 5:3)
        case (B[5:3])
            3'b000, 3'b111: pp2 = 9'b0;
            3'b001, 3'b010: pp2 = {A[7], A};
            3'b011: pp2 = {A, 1'b0};
            3'b100: pp2 = ~{A, 1'b0} + 1'b1;
            3'b101, 3'b110: pp2 = ~{A[7], A} + 1'b1;
        endcase
        
        // PP3 (bits 7:5)
        case (B[7:5])
            3'b000, 3'b111: pp3 = 9'b0;
            3'b001, 3'b010: pp3 = {A[7], A};
            3'b011: pp3 = {A, 1'b0};
            3'b100: pp3 = ~{A, 1'b0} + 1'b1;
            3'b101, 3'b110: pp3 = ~{A[7], A} + 1'b1;
        endcase
    end
endmodule

// 4:2 Compressor Module
module compressor_4to2 (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input cin,
    output [15:0] sum,
    output [15:0] carry,
    output cout
);
    wire [15:0] s1, c1, s2, c2;
    
    // First level of CSA
    assign s1 = a ^ b ^ c;
    assign c1 = (a & b) | (a & c) | (b & c);
    
    // Second level of CSA
    assign s2 = s1 ^ d ^ {15'b0, cin};
    assign c2 = (s1 & d) | (s1 & {15'b0, cin}) | (d & {15'b0, cin});
    
    assign sum = s2;
    assign carry = {c1[14:0], 1'b0} ^ c2;
    assign cout = c1[15] | c2[15];
endmodule

// Hybrid Adder (Kogge-Stone + RCA)
module hybrid_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Use Kogge-Stone for upper 8 bits
    wire [7:0] upper_sum;
    wire cout;
    kogge_stone #(.WIDTH(8)) upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b0),
        .sum(upper_sum),
        .cout(cout)
    );
    
    // Use RCA for lower 8 bits
    wire [7:0] lower_sum;
    rca #(.WIDTH(8)) lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(cout),
        .sum(lower_sum)
    );
    
    assign sum = {upper_sum, lower_sum};
endmodule

// Kogge-Stone Adder Module
module kogge_stone #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);
    // Implementation of Kogge-Stone parallel prefix adder
    // ... (implementation details omitted for brevity)
endmodule

// RCA Module
module rca #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum
);
    // Implementation of Ripple Carry Adder
    // ... (implementation details omitted for brevity)
endmodule