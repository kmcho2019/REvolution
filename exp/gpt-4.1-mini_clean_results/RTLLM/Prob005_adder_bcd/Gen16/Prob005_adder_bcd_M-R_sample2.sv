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
    wire [4:0] final_sum;

    // Step 1: Binary addition of inputs with carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed (sum > 9)
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Calculate corrected sum by adding 6 if overflow detected
    assign corrected_sum = raw_sum + 5'd6;

    // Step 4: Select final sum based on overflow
    assign final_sum = overflow ? corrected_sum : raw_sum;

    // Step 5: Output assignments
    assign Sum  = final_sum[3:0];
    assign Cout = final_sum[4];

endmodule