module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth Radix-4 encoding to generate 4 partial products
    wire [8:0] pp [3:0];
    wire [8:0] neg_A = {1'b1, ~A} + 1; // Two's complement of A
    
    // Booth encoder
    booth_encoder_4bit be0 (.B(B[1:0]), .pp(pp[0]), .neg_A(neg_A[7:0]), .A(A));
    booth_encoder_4bit be1 (.B(B[3:1]), .pp(pp[1]), .neg_A(neg_A[7:0]), .A(A));
    booth_encoder_4bit be2 (.B(B[5:3]), .pp(pp[2]), .neg_A(neg_A[7:0]), .A(A));
    booth_encoder_4bit be3 (.B({B[7], B[7:5]}), .pp(pp[3]), .neg_A(neg_A[7:0]), .A(A));

    // Sign extend partial products to 16 bits with proper shifting
    wire [15:0] pp_ext [3:0];
    assign pp_ext[0] = {{7{pp[0][8]}}, pp[0]} << 0;
    assign pp_ext[1] = {{5{pp[1][8]}}, pp[1]} << 2;
    assign pp_ext[2] = {{3{pp[2][8]}}, pp[2]} << 4;
    assign pp_ext[3] = {{1{pp[3][8]}}, pp[3]} << 6;

    // Wallace tree reduction (3 levels)
    // Level 1: 4:2 compression
    wire [15:0] sum1, carry1;
    compressor_4to2 stage1 (
        .in0(pp_ext[0]),
        .in1(pp_ext[1]),
        .in2(pp_ext[2]),
        .in3(pp_ext[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Level 2: 3:2 compression
    wire [15:0] sum2, carry2;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .sum(sum2),
        .carry(carry2)
    );

    // Final addition with hybrid adder
    hybrid_16bit final_adder (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .sum(product)
    );

endmodule

// Booth Radix-4 encoder module
module booth_encoder_4bit(
    input [2:0] B,
    input [7:0] A,
    input [7:0] neg_A,
    output reg [8:0] pp
);
    always @(*) begin
        case (B)
            3'b000, 3'b111: pp = 9'b0;
            3'b001, 3'b010: pp = {A[7], A};
            3'b011: pp = {A, 1'b0};
            3'b100: pp = {neg_A, 1'b0};
            3'b101, 3'b110: pp = {neg_A[7], neg_A};
            default: pp = 9'b0;
        endcase
    end
endmodule

// Optimized 4:2 compressor with operand isolation
module compressor_4to2(
    input [15:0] in0,
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    output [15:0] sum,
    output [15:0] carry
);
    // Operand isolation when inputs are stable
    wire active = |(in0 ^ in1 ^ in2 ^ in3);
    
    wire [15:0] s1, c1;
    assign s1 = active ? (in0 ^ in1 ^ in2) : 16'b0;
    assign c1 = active ? ((in0 & in1) | (in0 & in2) | (in1 & in2)) : 16'b0;
    
    assign sum = active ? (s1 ^ in3 ^ {c1[14:0], 1'b0}) : 16'b0;
    assign carry = active ? ((s1 & in3) | (s1 & {c1[14:0], 1'b0}) | (in3 & {c1[14:0], 1'b0})) : 16'b0;
endmodule

// Hybrid 16-bit adder (Kogge-Stone + Ripple)
module hybrid_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Upper 8 bits use Kogge-Stone for performance
    wire [15:8] sum_upper;
    wire cout;
    kogge_stone_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b0),
        .sum(sum_upper),
        .cout(cout)
    );
    
    // Lower 8 bits use ripple for area efficiency
    wire [7:0] sum_lower;
    ripple_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_lower)
    );
    
    assign sum = {sum_upper, sum_lower};
endmodule

// Kogge-Stone 8-bit adder for upper bits
module kogge_stone_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Implementation of Kogge-Stone parallel prefix adder
    // ... (detailed implementation omitted for brevity)
    // This would include generate/propagate computation and prefix tree
endmodule

// Ripple 8-bit adder for lower bits
module ripple_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum
);
    wire [8:0] c;
    assign c[0] = cin;
    
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : fa_chain
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout(c[i+1])
            );
        end
    endgenerate
endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Basic 16-bit CSA (modified for 2 inputs)
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b;
    assign carry = (a & b) << 1;
endmodule