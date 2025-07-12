module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    // Generate and Propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Carry computation
    wire [3:0] C;
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    // Sum computation
    assign S = P ^ C;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    // Group propagate and generate signals
    wire [3:0] G_group, P_group;
    wire [3:0] carry_out;
    
    // Generate 4-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_block
            wire [3:0] A_slice = A[(i*4)+3 : i*4];
            wire [3:0] B_slice = B[(i*4)+3 : i*4];
            wire carry_in = (i == 0) ? Cin : carry_out[i-1];
            
            cla_4bit cla_inst (
                .A(A_slice),
                .B(B_slice),
                .Cin(carry_in),
                .S(S[(i*4)+3 : i*4]),
                .Cout(carry_out[i])
            );
            
            // Group propagate/generate for lookahead
            assign P_group[i] = &P_slice;  // Group propagate is AND of all P
            assign G_group[i] = G_slice[3] | (P_slice[3] & G_slice[2]) | 
                              (P_slice[3] & P_slice[2] & G_slice[1]) | 
                              (P_slice[3] & P_slice[2] & P_slice[1] & G_slice[0]);
        end
    endgenerate
    
    // Final carry out
    assign Cout = carry_out[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    // Lower 16 bits
    cla_16bit low_16bit (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );
    
    // Upper 16 bits
    cla_16bit high_16bit (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule