module cla_2bit (
    input [1:0] A,
    input [1:0] B,
    input Cin,
    output [1:0] S,
    output Pg,
    output Gg
);
    wire [1:0] P, G;
    wire [1:0] C;
    
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    
    // Sum computation
    assign S = P ^ C;
    
    // Block propagate/generate
    assign Pg = P[1] & P[0];
    assign Gg = G[1] | (P[1] & G[0]);
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg,
    output Cout
);
    wire [3:0] Pg_2bit, Gg_2bit;
    wire [3:0] C;
    
    // Instantiate four 2-bit CLAs
    cla_2bit cla0 (.A(A[1:0]), .B(B[1:0]), .Cin(Cin), .S(S[1:0]), 
                  .Pg(Pg_2bit[0]), .Gg(Gg_2bit[0]));
    cla_2bit cla1 (.A(A[3:2]), .B(B[3:2]), .Cin(C[0]), .S(S[3:2]), 
                  .Pg(Pg_2bit[1]), .Gg(Gg_2bit[1]));
    cla_2bit cla2 (.A(A[5:4]), .B(B[5:4]), .Cin(C[1]), .S(S[5:4]), 
                  .Pg(Pg_2bit[2]), .Gg(Gg_2bit[2]));
    cla_2bit cla3 (.A(A[7:6]), .B(B[7:6]), .Cin(C[2]), .S(S[7:6]), 
                  .Pg(Pg_2bit[3]), .Gg(Gg_2bit[3]));
    
    // Carry lookahead between 2-bit blocks
    assign C[0] = Gg_2bit[0] | (Pg_2bit[0] & Cin);
    assign C[1] = Gg_2bit[1] | (Pg_2bit[1] & Gg_2bit[0]) | (Pg_2bit[1] & Pg_2bit[0] & Cin);
    assign C[2] = Gg_2bit[2] | (Pg_2bit[2] & Gg_2bit[1]) | (Pg_2bit[2] & Pg_2bit[1] & Gg_2bit[0]) | 
                 (Pg_2bit[2] & Pg_2bit[1] & Pg_2bit[0] & Cin);
    assign Cout = Gg_2bit[3] | (Pg_2bit[3] & Gg_2bit[2]) | (Pg_2bit[3] & Pg_2bit[2] & Gg_2bit[1]) | 
                 (Pg_2bit[3] & Pg_2bit[2] & Pg_2bit[1] & Gg_2bit[0]) | 
                 (Pg_2bit[3] & Pg_2bit[2] & Pg_2bit[1] & Pg_2bit[0] & Cin);
    
    // Block propagate/generate
    assign Pg = &Pg_2bit;
    assign Gg = Gg_2bit[3] | (Pg_2bit[3] & Gg_2bit[2]) | (Pg_2bit[3] & Pg_2bit[2] & Gg_2bit[1]) | 
               (Pg_2bit[3] & Pg_2bit[2] & Pg_2bit[1] & Gg_2bit[0]);
endmodule

module carry_select_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [7:0] S0, S1;
    wire Cout0, Cout1;
    wire Pg0, Gg0, Pg1, Gg1;
    wire carry_sel;
    
    // Lower 8-bit block (always computed)
    cla_8bit cla_low (.A(A[7:0]), .B(B[7:0]), .Cin(Cin), 
                     .S(S[7:0]), .Cout());
    
    // Upper 8-bit blocks (carry-select)
    // Compute for both possible carry-in cases
    cla_8bit cla_high0 (.A(A[15:8]), .B(B[15:8]), .Cin(1'b0),
                       .S(S0), .Pg(Pg0), .Gg(Gg0), .Cout(Cout0));
    cla_8bit cla_high1 (.A(A[15:8]), .B(B[15:8]), .Cin(1'b1),
                       .S(S1), .Pg(Pg1), .Gg(Gg1), .Cout(Cout1));
    
    // Generate actual carry from lower block
    wire low_Pg, low_Gg;
    cla_8bit cla_low_pg (.A(A[7:0]), .B(B[7:0]), .Cin(Cin),
                        .Pg(low_Pg), .Gg(low_Gg));
    
    // Carry select logic
    assign carry_sel = low_Gg | (low_Pg & Cin);
    assign S[15:8] = carry_sel ? S1 : S0;
    assign Cout = carry_sel ? Cout1 : Cout0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [15:0] S0, S1;
    wire Cout0, Cout1;
    wire carry_sel;
    
    // Lower 16-bit block (always computed)
    carry_select_16bit cs_low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0),
                             .S(S[16:1]), .Cout());
    
    // Upper 16-bit blocks (carry-select)
    carry_select_16bit cs_high0 (.A(A[32:17]), .B(B[32:17]), .Cin(1'b0),
                                .S(S0), .Cout(Cout0));
    carry_select_16bit cs_high1 (.A(A[32:17]), .B(B[32:17]), .Cin(1'b1),
                                .S(S1), .Cout(Cout1));
    
    // Generate actual carry from lower block
    wire low_Pg, low_Gg;
    carry_select_16bit cs_low_pg (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0),
                                .Pg(low_Pg), .Gg(low_Gg));
    
    // Carry select logic
    assign carry_sel = low_Gg | (low_Pg & 1'b0);  // Cin=0 for lower block
    assign S[32:17] = carry_sel ? S1 : S0;
    assign C32 = carry_sel ? Cout1 : Cout0;
endmodule