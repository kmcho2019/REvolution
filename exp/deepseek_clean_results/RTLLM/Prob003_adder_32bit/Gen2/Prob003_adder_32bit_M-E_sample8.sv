module booth_encoder_4bit (
    input [3:0] A,
    input [3:0] B,
    output [3:0] encoded_A,
    output [3:0] encoded_B,
    output [1:0] shift_amount
);
    // Radix-4 Booth encoding
    wire [4:0] diff = {1'b0,A} - {1'b0,B};
    assign shift_amount = (diff[4]) ? 2'b11 : // Special case for large negative
                        (diff[3:2] == 2'b11) ? 2'b10 : // -2
                        (diff[3:2] == 2'b10) ? 2'b01 : // -1
                        (diff[3:2] == 2'b01) ? 2'b01 : // +1
                        (diff[3:2] == 2'b00) ? 2'b00 : 2'b00; // 0 or +2
    
    assign encoded_A = (shift_amount == 2'b11) ? 4'b0000 : 
                      (shift_amount[1]) ? ~A + 1 : A;
    assign encoded_B = (shift_amount == 2'b11) ? 4'b0000 : 
                      (shift_amount[1]) ? ~B + 1 : B;
endmodule

module conditional_4bit_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S0,
    output [3:0] S1,
    output Cout0,
    output Cout1
);
    // Compute both possible sums in parallel
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;
    
    // Carry=0 case
    wire [4:0] C0 = {G[3] | (P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & G[0]),
                    G[2] | (P[2] & G[1] | P[2] & P[1] & G[0]),
                    G[1] | (P[1] & G[0]),
                    G[0],
                    Cin};
    
    // Carry=1 case
    wire [4:0] C1 = {G[3] | (P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & (G[0] | P[0])),
                    G[2] | (P[2] & G[1] | P[2] & P[1] & (G[0] | P[0])),
                    G[1] | (P[1] & (G[0] | P[0])),
                    G[0] | P[0],
                    1'b1};
    
    assign S0 = P ^ C0[3:0];
    assign S1 = P ^ C1[3:0];
    assign Cout0 = C0[4];
    assign Cout1 = C1[4];
endmodule

module hybrid_32bit_adder (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Stage 1: Booth Encoding (8 groups of 4 bits)
    wire [7:0][3:0] encoded_A, encoded_B;
    wire [7:0][1:0] shift_amounts;
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : booth_encode
            booth_encoder_4bit encoder (
                .A(A[i*4+4:i*4+1]),
                .B(B[i*4+4:i*4+1]),
                .encoded_A(encoded_A[i]),
                .encoded_B(encoded_B[i]),
                .shift_amount(shift_amounts[i])
            );
        end
    endgenerate
    
    // Stage 2: Conditional Sum Addition (8 groups)
    wire [7:0][3:0] S0, S1;
    wire [7:0] Cout0, Cout1;
    wire [8:0] carry_chain = {1'b0};
    
    generate
        for (i=0; i<8; i=i+1) begin : cond_add
            conditional_4bit_adder adder (
                .A(encoded_A[i]),
                .B(encoded_B[i]),
                .Cin(carry_chain[i]),
                .S0(S0[i]),
                .S1(S1[i]),
                .Cout0(Cout0[i]),
                .Cout1(Cout1[i])
            );
            
            // Carry prediction logic
            wire carry_pred = (i == 0) ? 1'b0 :
                             (shift_amounts[i-1] == 2'b11) ? 1'b1 :
                             (encoded_A[i-1] + encoded_B[i-1] > 15) ? 1'b1 : 1'b0;
            
            // Mux correct sum based on predicted carry
            assign S[i*4+4:i*4+1] = carry_pred ? S1[i] : S0[i];
            assign carry_chain[i+1] = carry_pred ? Cout1[i] : Cout0[i];
        end
    endgenerate
    
    // Final carry out
    assign C32 = carry_chain[8];
    
    // Correction logic for mispredicted carries
    always @(*) begin
        for (integer j=1; j<8; j=j+1) begin
            if (carry_chain[j] != (encoded_A[j-1] + encoded_B[j-1] + carry_chain[j-1] > 15)) begin
                // Recompute affected sums (this would be pipelined in real implementation)
                S[j*4+4:j*4+1] = (carry_chain[j]) ? S0[j] : S1[j];
                carry_chain[j+1] = (carry_chain[j]) ? Cout0[j] : Cout1[j];
            end
        end
    end
endmodule