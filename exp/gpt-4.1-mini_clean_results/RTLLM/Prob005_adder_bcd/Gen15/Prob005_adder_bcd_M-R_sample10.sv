module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);

    reg [4:0] raw_sum;
    reg       correction_needed;
    reg [4:0] corrected_sum;

    always @* begin
        // Binary addition of inputs with carry-in
        raw_sum = {1'b0, A} + {1'b0, B} + Cin;

        // Determine if correction is needed (raw_sum > 9)
        correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

        // Apply BCD correction if needed
        if (correction_needed)
            corrected_sum = raw_sum + 5'b00110; // Add 6
        else
            corrected_sum = raw_sum;

        // Update outputs
        Sum  = corrected_sum[3:0];
        Cout = corrected_sum[4];
    end

endmodule