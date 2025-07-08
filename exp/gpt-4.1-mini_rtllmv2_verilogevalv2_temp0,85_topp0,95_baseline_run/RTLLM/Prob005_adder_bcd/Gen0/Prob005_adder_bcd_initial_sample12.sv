module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] binary_sum;
    wire [4:0] corrected_sum;
    wire       add_correction;

    // Initial binary addition including carry-in
    assign binary_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9)
    assign add_correction = (binary_sum > 5'd9);

    // Add correction (6) if needed
    assign corrected_sum = add_correction ? (binary_sum + 5'd6) : binary_sum;

    // Output sum and carry
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule