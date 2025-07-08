module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire [4:0] corrected_sum;
    wire       needs_correction;

    // Step 1: Binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed (sum > 9)
    assign needs_correction = (binary_sum > 5'd9);

    // Step 3: Add correction (6) if needed
    assign corrected_sum = needs_correction ? (binary_sum + 5'd6) : binary_sum;

    // Step 4: Output the lower 4 bits as Sum and the MSB as Cout
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule