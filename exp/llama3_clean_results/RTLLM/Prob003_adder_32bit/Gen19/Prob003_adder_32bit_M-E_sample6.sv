// Carry Predictor module
module carry_predictor(
    input [3:1] A,
    input [3:1] B,
    output C_pred
);
    assign C_pred = (A[3] & B[3]) | (A[3] & A[2] & B[2]) | (A[3] & A[2] & A[1] & B[1]);
endmodule

// 4-bit Ripple-Carry Adder module
module rca_4bit(
    input [3:1] A,
    input [3:1] B,
    input C_in,
    output [3:1] S,
    output C_out
);
    wire C1, C2, C3;

    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign C1 = (A[1] & B[1]) | (A[1] & C_in) | (B[1] & C_in);

    assign S[2] = A[2] ^ B[2] ^ C1;
    assign C2 = (A[2] & B[2]) | (A[2] & C1) | (B[2] & C1);

    assign S[3] = A[3] ^ B[3] ^ C2;
    assign C_out = (A[3] & B[3]) | (A[3] & C2) | (B[3] & C2);
endmodule

// Segmented Carry-Lookahead Adder module
module scla_32bit(
    input [31:1] A,
    input [31:1] B,
    output [31:1] S,
    output C32
);
    wire [7:1] C_pred;
    wire [7:1] C_out;
    wire [31:1] S_int;

    // Instantiate carry predictor modules
    generate
        for (genvar i = 1; i <= 8; i++) begin
            carry_predictor u_pred(
               .A(A[(i*4)-3:(i*4)-4]),
               .B(B[(i*4)-3:(i*4)-4]),
               .C_pred(C_pred[i])
            );
        end
    endgenerate

    // Instantiate 4-bit RCA modules
    generate
        for (genvar i = 1; i <= 8; i++) begin
            rca_4bit u_rca(
               .A(A[(i*4)-3:(i*4)-4]),
               .B(B[(i*4)-3:(i*4)-4]),
               .C_in(C_pred[i-1]),
               .S(S_int[(i*4)-3:(i*4)-4]),
               .C_out(C_out[i])
            );
        end
    endgenerate

    // Compute final sum and carry-out
    assign S = S_int;
    assign C32 = C_out[8];
endmodule