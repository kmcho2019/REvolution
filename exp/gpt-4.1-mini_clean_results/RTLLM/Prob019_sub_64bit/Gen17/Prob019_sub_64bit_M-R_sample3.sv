module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement B once for subtraction
    wire [63:0] B_comp = ~B;

    // Internal carry signals: 64 carries for bits 0 to 63, and final carry out
    wire [64:0] carry;
    assign carry[0] = 1'b1;  // initial carry-in for two's complement subtraction (+1)

    // Propagate and generate signals for each bit
    wire [63:0] P = A ^ B_comp;
    wire [63:0] G = A & B_comp;

    // Compute carry chain combinationally using assign statements
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_gen
            assign carry[i+1] = G[i] | (P[i] & carry[i]);
        end
    endgenerate

    // Final sum bits: sum = propagate XOR carry-in
    assign result = P ^ carry[63:0];

    // Overflow detection: 
    // Overflow occurs if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule