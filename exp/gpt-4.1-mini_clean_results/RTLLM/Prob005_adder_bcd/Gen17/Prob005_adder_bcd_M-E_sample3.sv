module adder_bcd (
    input  [3:0] A,    // First BCD digit (0-9)
    input  [3:0] B,    // Second BCD digit (0-9)
    input        Cin,  // Carry in
    output [3:0] Sum,  // Corrected BCD sum digit
    output       Cout  // Carry out if sum > 9
);

    // 5-bit raw sum: A + B + Cin
    wire [4:0] raw_sum;
    binary_adder_4bit #(.WIDTH(4)) add_AB (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(raw_sum[3:0]),
        .Cout(raw_sum[4])
    );

    // Correction needed if raw_sum > 9
    // 9 decimal = 01001 binary
    // raw_sum is 5 bits, so compare raw_sum to 9
    // Correction needed if raw_sum > 9
    wire correction_needed = (raw_sum[4]) // sum >= 16
                            | ( (raw_sum[3] & (raw_sum[2] | raw_sum[1])) )
                            | (raw_sum[3] & ~raw_sum[2] & ~raw_sum[1] & raw_sum[0]); 
    // Above expression corresponds to raw_sum > 9

    // Define constant 6 for correction (0110)
    localparam [3:0] CORRECT = 4'b0110;

    // Correction adder outputs
    wire [3:0] corrected_sum;
    wire       correction_cout;

    // If correction_needed is high, add 6 to raw_sum[3:0], else pass raw_sum directly
    binary_adder_4bit #(.WIDTH(4)) add_correction (
        .A(raw_sum[3:0]),
        .B(correction_needed ? CORRECT : 4'b0000),
        .Cin(1'b0),
        .Sum(corrected_sum),
        .Cout(correction_cout)
    );

    // Assign final sum and carry out
    assign Sum = corrected_sum;
    assign Cout = raw_sum[4] | correction_cout;

endmodule


// Parameterized 4-bit binary adder with carry-in and carry-out
module binary_adder_4bit #(parameter WIDTH = 4) (
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input              Cin,
    output [WIDTH-1:0] Sum,
    output             Cout
);
    wire [WIDTH:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for(i=0; i<WIDTH; i=i+1) begin : adder_bits
            assign Sum[i] = A[i] ^ B[i] ^ carry[i];
            assign carry[i+1] = (A[i] & B[i]) | (A[i] & carry[i]) | (B[i] & carry[i]);
        end
    endgenerate

    assign Cout = carry[WIDTH];
endmodule