module multi_8bit (
    input clk,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Pipeline stage 1: Generate and shift partial products (only when B bit is 1)
    wire [15:0] pp [7:0];
    assign pp[0] = B[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // Pipeline register
    reg [15:0] pp_reg [7:0];
    always @(posedge clk) begin
        for (integer i = 0; i < 8; i = i + 1)
            pp_reg[i] <= pp[i];
    end

    // Wallace Tree compression (3:2 counters)
    wire [15:0] s1 [2:0], c1 [2:0];
    wire [15:0] s2 [1:0], c2 [1:0];
    wire [15:0] s3, c3;

    // First level compression
    carry_save_adder csa1 (pp_reg[0], pp_reg[1], pp_reg[2], s1[0], c1[0]);
    carry_save_adder csa2 (pp_reg[3], pp_reg[4], pp_reg[5], s1[1], c1[1]);
    carry_save_adder csa3 (pp_reg[6], pp_reg[7], 16'b0, s1[2], c1[2]);

    // Second level compression
    carry_save_adder csa4 (s1[0], c1[0] << 1, s1[1], s2[0], c2[0]);
    carry_save_adder csa5 (c1[1] << 1, s1[2], c1[2] << 1, s2[1], c2[1]);

    // Third level compression
    carry_save_adder csa6 (s2[0], c2[0] << 1, s2[1], s3, c3);

    // Final addition with CLA
    wire [15:0] final_sum;
    cla_16bit final_adder (
        .a(s3),
        .b(c3 << 1),
        .sum(final_sum)
    );

    // Output register
    always @(posedge clk) begin
        product <= final_sum;
    end

endmodule

// Carry Save Adder module (3:2 compressor)
module carry_save_adder (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] s,
    output [15:0] cout
);
    assign s = a ^ b ^ c;
    assign cout = (a & b) | (a & c) | (b & c);
endmodule

// 16-bit Carry Lookahead Adder
module cla_16bit (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [16:0] carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: cla
            wire p, g;
            assign p = a[i] ^ b[i];
            assign g = a[i] & b[i];
            assign carry[i+1] = g | (p & carry[i]);
            assign sum[i] = p ^ carry[i];
        end
    endgenerate
endmodule