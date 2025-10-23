module cla_4bit_base (
    input [3:0] A,
    input [3:0] B,
    output [3:0] P,
    output [3:0] G
);
    assign P = A ^ B;
    assign G = A & B;
endmodule

module prefix_operator (
    input P1, G1,
    input P2, G2,
    output Po, Go
);
    assign Po = P1 & P2;
    assign Go = G2 | (P2 & G1);
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] P, G;
    wire [3:0] Pg, Gg; // Group propagate/generate
    wire [15:0] C;
    
    // Generate base 4-bit blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i+1) begin : base_blocks
            cla_4bit_base base (
                .A(A[(i*4)+3:i*4]),
                .B(B[(i*4)+3:i*4]),
                .P(P[(i*4)+3:i*4]),
                .G(G[(i*4)+3:i*4])
            );
            
            // Compute group propagate/generate
            assign Pg[i] = &P[(i*4)+3:i*4];
            assign Gg[i] = G[i*4+3] | 
                          (P[i*4+3] & G[i*4+2]) | 
                          (P[i*4+3] & P[i*4+2] & G[i*4+1]) | 
                          (P[i*4+3] & P[i*4+2] & P[i*4+1] & G[i*4]);
        end
    endgenerate
    
    // Brent-Kung parallel prefix tree for carry computation
    wire [1:0] Pg_mid, Gg_mid;
    
    // First level prefix operators
    prefix_operator po0 (.P1(Pg[0]), .G1(Gg[0]), .P2(Pg[1]), .G2(Gg[1]),
                       .Po(Pg_mid[0]), .Go(Gg_mid[0]));
    prefix_operator po1 (.P1(Pg[2]), .G1(Gg[2]), .P2(Pg[3]), .G2(Gg[3]),
                       .Po(Pg_mid[1]), .Go(Gg_mid[1]));
    
    // Second level prefix operator
    wire Pg_top, Gg_top;
    prefix_operator po_top (.P1(Pg_mid[0]), .G1(Gg_mid[0]), 
                          .P2(Pg_mid[1]), .G2(Gg_mid[1]),
                          .Po(Pg_top), .Go(Gg_top));
    
    // Compute intermediate carries
    wire [3:0] group_carry;
    assign group_carry[0] = Cin;
    assign group_carry[1] = Gg[0] | (Pg[0] & Cin);
    assign group_carry[2] = Gg_mid[0] | (Pg_mid[0] & Cin);
    assign group_carry[3] = Gg[2] | (Pg[2] & group_carry[2]);
    
    // Generate final carries
    generate
        for (i = 0; i < 4; i = i+1) begin : carry_gen
            if (i == 0) begin
                assign C[i*4] = group_carry[i];
            end else begin
                assign C[i*4] = group_carry[i];
            end
            
            assign C[i*4+1] = G[i*4] | (P[i*4] & C[i*4]);
            assign C[i*4+2] = G[i*4+1] | (P[i*4+1] & C[i*4+1]);
            assign C[i*4+3] = G[i*4+2] | (P[i*4+2] & C[i*4+2]);
        end
    endgenerate
    
    // Compute sum
    assign S = P ^ {C[14:0], Cin};
    assign Cout = Gg_top | (Pg_top & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    wire Pg_low, Gg_low;
    wire Pg_high, Gg_high;
    
    // First 16-bit block
    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );
    
    // Second 16-bit block
    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule