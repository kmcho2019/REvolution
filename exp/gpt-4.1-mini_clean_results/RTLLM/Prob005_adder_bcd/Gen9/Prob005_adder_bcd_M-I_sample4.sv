module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);
    reg [4:0] raw_sum;
    reg       overflow;
    reg [4:0] corrected_sum;

    always @(*) begin
        // Step 1: Binary addition of inputs and carry-in
        raw_sum = A + B + Cin;

        // Step 2: Detect if raw_sum > 9 (decimal 9)
        // raw_sum is 5-bit, so check if greater than 9:
        // overflow if raw_sum > 9
        if (raw_sum > 5'd9)
            overflow = 1'b1;
        else
            overflow = 1'b0;

        // Step 3: If overflow, add correction 6 (decimal 6)
        if (overflow)
            corrected_sum = raw_sum + 5'd6;
        else
            corrected_sum = raw_sum;

        // Step 4: Assign outputs: lower 4 bits as Sum, MSB as Cout
        Sum  = corrected_sum[3:0];
        Cout = corrected_sum[4];
    end
endmodule