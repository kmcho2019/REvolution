module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder outputs
    wire [1:0] booth [3:0];
    wire [8:0] booth_A = {A[7], A}; // Sign-extended A for 2's complement
    
    // Radix-4 Booth encoding
    assign booth[0] = {B[1], B[0], 1'b0};
    assign booth[1] = {B[3], B[2], B[1]};
    assign booth[2] = {B[5], B[4], B[3]};
    assign booth[3] = {B[7], B[6], B[5]};

    // Partial product generation
    wire [9:0] pp [3:0];
    
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : pp_gen
            wire neg, dbl, zero;
            booth_decoder bd(
                .b(booth[i]),
                .neg(neg),
                .dbl(dbl),
                .zero(zero)
            );
            
            wire [8:0] selected_A = neg ? ~booth_A : booth_A;
            wire [8:0] selected_2A = dbl ? {selected_A[7:0], 1'b0} : selected_A;
            wire [9:0] pp_raw = {selected_2A[8], selected_2A} + {9'b0, neg & ~dbl};
            
            assign pp[i] = zero ? 10'b0 : pp_raw;
        end
    endgenerate

    // Aligned partial products
    wire [15:0] aligned_pp [3:0];
    assign aligned_pp[0] = {{6{pp[0][9]}}, pp[0]};
    assign aligned_pp[1] = {{4{pp[1][9]}}, pp[1], 2'b0};
    assign aligned_pp[2] = {{2{pp[2][9]}}, pp[2], 4'b0};
    assign aligned_pp[3] = {pp[3], 6'b0};

    // Carry-select adder structure
    wire [15:0] sum0, sum1;
    wire [15:0] carry0, carry1;
    
    // First level: Add pp0 and pp1
    carry_select_adder #(16) csa0(
        .a(aligned_pp[0]),
        .b(aligned_pp[1]),
        .cin(1'b0),
        .sum(sum0),
        .cout(carry0)
    );
    
    // Second level: Add pp2 and pp3
    carry_select_adder #(16) csa1(
        .a(aligned_pp[2]),
        .b(aligned_pp[3]),
        .cin(1'b0),
        .sum(sum1),
        .cout(carry1)
    );
    
    // Final addition
    carry_select_adder #(16) final_adder(
        .a(sum0),
        .b(sum1),
        .cin(1'b0),
        .sum(product),
        .cout() // Unused
    );

endmodule

// Booth decoder module
module booth_decoder(
    input [2:0] b,
    output neg,
    output dbl,
    output zero
);
    assign neg = b[2];
    assign dbl = (b[1:0] == 2'b01) | (b[1:0] == 2'b10);
    assign zero = (b[2:0] == 3'b000) | (b[2:0] == 3'b111);
endmodule

// Parameterized carry-select adder
module carry_select_adder #(parameter WIDTH=16)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);
    localparam BLOCK_SIZE = 4;
    localparam NUM_BLOCKS = WIDTH/BLOCK_SIZE;
    
    wire [NUM_BLOCKS:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i=0; i<NUM_BLOCKS; i=i+1) begin : csa_block
            wire [BLOCK_SIZE-1:0] sum0, sum1;
            wire cout0, cout1;
            
            // Compute sum assuming carry-in 0
            ripple_adder #(BLOCK_SIZE) ra0(
                .a(a[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .b(b[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .cin(1'b0),
                .sum(sum0),
                .cout(cout0)
            );
            
            // Compute sum assuming carry-in 1
            ripple_adder #(BLOCK_SIZE) ra1(
                .a(a[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .b(b[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .cin(1'b1),
                .sum(sum1),
                .cout(cout1)
            );
            
            // Select correct sum based on previous carry
            assign sum[i*BLOCK_SIZE +: BLOCK_SIZE] = carry[i] ? sum1 : sum0;
            assign carry[i+1] = carry[i] ? cout1 : cout0;
        end
    endgenerate
    
    assign cout = carry[NUM_BLOCKS];
endmodule

// Parameterized ripple carry adder
module ripple_adder #(parameter WIDTH=4)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);
    wire [WIDTH:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i=0; i<WIDTH; i=i+1) begin : rca
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign cout = carry[WIDTH];
endmodule