module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Local parameter for correction value (6 decimal)
    localparam [4:0] CORRECTION = 5'd6;

    // Step 1: Raw binary addition of inputs with carry-in
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Determine if correction is needed (raw_sum > 9)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Calculate final sum with correction if needed
    wire [4:0] final_sum = raw_sum + (correction_needed ? CORRECTION : 5'd0);

    // Step 4: Assign outputs
    assign Sum  = final_sum[3:0];
    assign Cout = correction_needed;

endmodule