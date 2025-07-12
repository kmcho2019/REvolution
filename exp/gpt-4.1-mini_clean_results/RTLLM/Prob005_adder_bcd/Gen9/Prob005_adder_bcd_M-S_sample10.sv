module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       overflow;
    wire [4:0] corrected_sum;

    // Step 1: Add inputs with carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if sum > 9
    assign overflow = (raw_sum > 5'd9);

    // Step 3: If overflow, add 6 (0110) to low 4 bits; else no correction
    assign corrected_sum = overflow ? (raw_sum[3:0] + 4'd6) + (raw_sum[4] << 4) : raw_sum;

    // Step 4: Assign output sum and carry out from corrected_sum
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule