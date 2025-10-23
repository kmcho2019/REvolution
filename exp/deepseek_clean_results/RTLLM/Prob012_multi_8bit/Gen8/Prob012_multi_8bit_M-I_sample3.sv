module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Booth Encoded Partial Products (Radix-4)
    wire [8:0] pp [3:0];  // 4 partial products instead of 8
    wire [8:0] neg_A = {1'b1, ~A} + 1;  // Two's complement of A
    
    // Booth encoding groups
    wire [2:0] booth_sel [3:0];
    assign booth_sel[0] = {B[1], B[0], 1'b0};
    assign booth_sel[1] = B[3:1];
    assign booth_sel[2] = B[5:3];
    assign booth_sel[3] = B[7:5];
    
    // Generate partial products based on Booth encoding
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : booth_pp
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: pp[i] = 9'b0;          // 0
                    3'b001, 3'b010: pp[i] = {1'b0, A};    // +A
                    3'b011:         pp[i] = {A, 1'b0};     // +2A
                    3'b100:         pp[i] = {neg_A, 1'b0}; // -2A
                    3'b101, 3'b110: pp[i] = neg_A;         // -A
                endcase
            end
        end
    endgenerate

    // Sign-extended partial products for Wallace tree
    wire [15:0] pp_ext [3:0];
    assign pp_ext[0] = {{7{pp[0][8]}}, pp[0]};
    assign pp_ext[1] = {{5{pp[1][8]}}, pp[1], 2'b0};
    assign pp_ext[2] = {{3{pp[2][8]}}, pp[2], 4'b0};
    assign pp_ext[3] = {{1{pp[3][8]}}, pp[3], 6'b0};

    // Wallace Tree Compression (4:2 compressor)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    // First level compression
    compressor_4_2 wallace_level1 (
        .a(pp_ext[0]),
        .b(pp_ext[1]),
        .c(pp_ext[2]),
        .d(pp_ext[3]),
        .sum(sum1),
        .carry(carry1)
    );
    
    // Second level compression
    compressor_4_2 wallace_level2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(16'b0),
        .d(16'b0),
        .sum(sum2),
        .carry(carry2)
    );
    
    // Final addition using carry-select adder
    wire [15:0] final_sum;
    carry_select_adder final_adder (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .sum(final_sum)
    );
    
    always @(*) begin
        product = final_sum;
    end

endmodule

// 4:2 Compressor for Wallace Tree
module compressor_4_2 (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] s1 = a ^ b ^ c;
    wire [15:0] c1 = (a & b) | (a & c) | (b & c);
    
    assign sum = s1 ^ d;
    assign carry = (s1 & d) | (c1 << 1);
endmodule

// 16-bit Carry-Select Adder
module carry_select_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [15:0] sum0, sum1;
    wire cout0, cout1;
    
    // Generate two sums in parallel (one assuming cin=0, one assuming cin=1)
    ripple_adder adder0 (.a(a), .b(b), .cin(1'b0), .sum(sum0), .cout(cout0));
    ripple_adder adder1 (.a(a), .b(b), .cin(1'b1), .sum(sum1), .cout(cout1));
    
    // Select correct sum based on actual carry-in
    wire cin = 1'b0;  // Initial carry-in is 0
    wire [3:0] carry_chain;
    
    // 4-bit blocks with carry chain
    assign carry_chain[0] = (a[3:0] + b[3:0] + cin) >> 4;
    assign sum[3:0] = carry_chain[0] ? sum1[3:0] : sum0[3:0];
    
    assign carry_chain[1] = (a[7:4] + b[7:4] + carry_chain[0]) >> 4;
    assign sum[7:4] = carry_chain[1] ? sum1[7:4] : sum0[7:4];
    
    assign carry_chain[2] = (a[11:8] + b[11:8] + carry_chain[1]) >> 4;
    assign sum[11:8] = carry_chain[2] ? sum1[11:8] : sum0[11:8];
    
    assign carry_chain[3] = (a[15:12] + b[15:12] + carry_chain[2]) >> 4;
    assign sum[15:12] = carry_chain[3] ? sum1[15:12] : sum0[15:12];
endmodule

// Basic Ripple Carry Adder (used in carry-select)
module ripple_adder (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [16:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : adder
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign cout = carry[16];
endmodule