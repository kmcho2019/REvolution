module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Generate and propagate signals for carry lookahead
    wire [3:0] G = A & B;
    wire [3:0] P = A | B;

    // Carry lookahead calculation
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    wire C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
              (P[3] & P[2] & P[1] & P[0] & Cin);

    // Calculate both possible sums in parallel
    wire [3:0] sum_raw = A ^ B ^ {C3, C2, C1, Cin};
    wire [3:0] sum_corrected = sum_raw + 4'd6;

    // Detect overflow condition (sum > 9 or carry out)
    wire overflow = C4 | (sum_raw[3] & (sum_raw[2] | sum_raw[1]));

    // Select correct result based on overflow condition
    assign Sum = overflow ? sum_corrected : sum_raw;
    assign Cout = overflow;

endmodule