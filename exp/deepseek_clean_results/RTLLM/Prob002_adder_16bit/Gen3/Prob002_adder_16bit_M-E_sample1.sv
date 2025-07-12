module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output Pg,
    output Gg
);
    // Generate and propagate signals
    wire [3:0] G = a & b;
    wire [3:0] P = a ^ b;
    
    // Carry lookahead logic
    wire c1 = G[0] | (P[0] & Cin);
    wire c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    wire c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
              (P[3] & P[2] & P[1] & P[0] & Cin);
    
    // Sum calculation
    assign sum[0] = P[0] ^ Cin;
    assign sum[1] = P[1] ^ c1;
    assign sum[2] = P[2] ^ c2;
    assign sum[3] = P[3] ^ c3;
    
    // Block generate and propagate
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign Pg = P[3] & P[2] & P[1] & P[0];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Intermediate carries and sum selects
    wire [3:0] Pg, Gg;
    wire [3:0] block_carry;
    wire [15:0] sum0, sum1;
    
    // First block (always computed with Cin)
    adder_4bit_cla block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(y[3:0]),
        .Pg(Pg[0]),
        .Gg(Gg[0])
    );
    
    // Carry-select blocks (compute both possibilities)
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : cs_blocks
            // Compute block with carry=0
            adder_4bit_cla block0 (
                .a(a[4*i+3 : 4*i]),
                .b(b[4*i+3 : 4*i]),
                .Cin(1'b0),
                .sum(sum0[4*i+3 : 4*i]),
                .Pg(),
                .Gg()
            );
            
            // Compute block with carry=1
            adder_4bit_cla block1 (
                .a(a[4*i+3 : 4*i]),
                .b(b[4*i+3 : 4*i]),
                .Cin(1'b1),
                .sum(sum1[4*i+3 : 4*i]),
                .Pg(),
                .Gg()
            );
            
            // Generate block carry
            if (i == 1) begin
                assign block_carry[i] = Gg[i-1] | (Pg[i-1] & Cin);
            end else begin
                assign block_carry[i] = Gg[i-1] | (Pg[i-1] & block_carry[i-1]);
            end
            
            // Mux correct sum based on actual carry
            assign y[4*i+3 : 4*i] = block_carry[i] ? sum1[4*i+3 : 4*i] : sum0[4*i+3 : 4*i];
        end
    endgenerate
    
    // Final carry out
    assign Co = Gg[3] | (Pg[3] & block_carry[3]);
endmodule