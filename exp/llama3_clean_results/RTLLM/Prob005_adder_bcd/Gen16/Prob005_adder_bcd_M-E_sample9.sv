module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Define a 2D array to store pre-computed results
    // The array size is 10x10x2 to account for all possible combinations of A, B, and Cin
    reg [3:0] sum_lut [9:0][9:0];
    reg [0:0] cout_lut [9:0][9:0];

    // Initialize the LUTs with pre-computed values
    initial begin
        for (int i = 0; i <= 9; i++) begin
            for (int j = 0; j <= 9; j++) begin
                // Perform binary addition and apply BCD correction
                reg [4:0] temp_sum = i + j + Cin;
                if (temp_sum > 9) begin
                    temp_sum = temp_sum + 6;
                end
                sum_lut[i][j] = temp_sum[3:0];
                cout_lut[i][j] = temp_sum[4];
            end
        end
    end

    // Use the LUTs to look up the result based on the input values
    assign Sum = sum_lut[A][B];
    assign Cout = cout_lut[A][B];

endmodule