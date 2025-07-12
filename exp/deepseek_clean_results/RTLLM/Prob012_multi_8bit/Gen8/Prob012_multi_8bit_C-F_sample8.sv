module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth Radix-4 encoding to reduce partial products
    wire [8:0] booth_sel;
    wire [15:0] pp [3:0];
    
    // Booth encoder
    assign booth_sel[0] = B[1] & ~B[0];
    assign booth_sel[1] = B[3] & ~B[2];
    assign booth_sel[2] = B[5] & ~B[4];
    assign booth_sel[3] = B[7] & ~B[6];
    assign booth_sel[4] = ~B[1] & B[0];
    assign booth_sel[5] = ~B[3] & B[2];
    assign booth_sel[6] = ~B[5] & B[4];
    assign booth_sel[7] = ~B[7] & B[6];
    assign booth_sel[8] = B[7];  // Sign bit for negative multiples
    
    // Generate partial products (only 4 needed with Booth encoding)
    assign pp[0] = ({16{booth_sel[0]}} & { {6{1'b0}}, A, 2'b0 }) |  // +A<<2
                   ({16{booth_sel[4]}} & { {7{1'b0}}, A, 1'b0 }) |  // +A<<1
                   ({16{booth_sel[8]}} & { {8{1'b0}}, ~A + 1'b1 }); // -A
    
    assign pp[1] = ({16{booth_sel[1]}} & { {4{1'b0}}, A, 4'b0 }) |  // +A<<4
                   ({16{booth_sel[5]}} & { {5{1'b0}}, A, 3'b0 }) |  // +A<<3
                   ({16{booth_sel[8]}} & { {8{1'b0}}, ~A + 1'b1 }); // -A
    
    assign pp[2] = ({16{booth_sel[2]}} & { {2{1'b0}}, A, 6'b0 }) |  // +A<<6
                   ({16{booth_sel[6]}} & { {3{1'b0}}, A, 5'b0 }) |  // +A<<5
                   ({16{booth_sel[8]}} & { {8{1'b0}}, ~A + 1'b1 }); // -A
    
    assign pp[3] = ({16{booth_sel[3]}} & { A, 8'b0 }) |             // +A<<8
                   ({16{booth_sel[7]}} & { {1{1'b0}}, A, 7'b0 }) |  // +A<<7
                   ({16{booth_sel[8]}} & { {8{1'b0}}, ~A + 1'b1 }); // -A

    // 4:2 compressor tree for partial product reduction
    wire [15:0] sum1, carry1, sum2, carry2;
    compressor_4to2 comp1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .cin(16'b0),
        .sum(sum1),
        .carry(carry1),
        .cout()
    );
    
    // Final addition with hybrid adder (CLA for upper bits, RCA for lower)
    hybrid_adder final_adder (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .sum(product)
    );

endmodule

// 4:2 compressor module (more efficient than CSA)
module compressor_4to2 (
    input [15:0] in0, in1, in2, in3,
    input [15:0] cin,
    output [15:0] sum, carry,
    output cout
);
    wire [15:0] s1 = in0 ^ in1;
    wire [15:0] c1 = in0 & in1;
    
    wire [15:0] s2 = s1 ^ in2;
    wire [15:0] c2 = (s1 & in2) | c1;
    
    assign sum = s2 ^ in3;
    assign carry = (s2 & in3) | c2;
    assign cout = |(carry & cin);  // Not used in this implementation
endmodule

// Hybrid adder (CLA for MSBs, RCA for LSBs)
module hybrid_adder (
    input [15:0] a, b,
    output [15:0] sum
);
    // RCA for lower 8 bits (better area for less critical path)
    wire [7:0] sum_lo;
    wire cout_lo;
    rca #(8) rca_lo (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_lo),
        .cout(cout_lo)
    );
    
    // CLA for upper 8 bits (better timing for critical path)
    wire [7:0] sum_hi;
    cla #(8) cla_hi (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout_lo),
        .sum(sum_hi)
    );
    
    assign sum = {sum_hi, sum_lo};
endmodule

// 8-bit Ripple Carry Adder
module rca #(parameter WIDTH=8) (
    input [WIDTH-1:0] a, b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);
    wire [WIDTH:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : rca_loop
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign cout = carry[WIDTH];
endmodule

// 8-bit Carry Lookahead Adder
module cla #(parameter WIDTH=8) (
    input [WIDTH-1:0] a, b,
    input cin,
    output [WIDTH-1:0] sum
);
    wire [WIDTH:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : cla_loop
            wire p = a[i] ^ b[i];
            wire g = a[i] & b[i];
            assign carry[i+1] = g | (p & carry[i]);
            assign sum[i] = p ^ carry[i];
        end
    endgenerate
endmodule