module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);
    reg [4:0] binary_sum;  // 5-bit to capture carry out and sum
    reg [4:0] corrected_sum;

    always @(*) begin
        // Step 1: Add inputs
        binary_sum = A + B + Cin;

        // Step 2: Detect if correction needed
        if ((binary_sum > 5'd9)) begin
            corrected_sum = binary_sum + 5'd6; // Add correction
        end else begin
            corrected_sum = binary_sum;
        end

        // Step 3: Assign outputs
        Sum  = corrected_sum[3:0];
        Cout = corrected_sum[4];
    end

endmodule