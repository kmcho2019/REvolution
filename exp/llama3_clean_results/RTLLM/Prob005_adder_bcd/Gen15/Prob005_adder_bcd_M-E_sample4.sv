// Define a module for the 4-bit BCD adder using a lookup table (LUT)
module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Define the LUT for BCD addition
    reg [3:0] lut_sum [0:9];
    reg [0:0] lut_cout [0:9];

    // Initialize the LUT with pre-computed values
    initial begin
        for (int i = 0; i <= 9; i++) begin
            for (int j = 0; j <= 9; j++) begin
                for (int k = 0; k <= 1; k++) begin
                    reg [4:0] bin_sum;
                    bin_sum = i + j + k;
                    if (bin_sum > 9) begin
                        lut_sum[(i * 10 + j) * 2 + k] = bin_sum[3:0] + 4'd6;
                        lut_cout[(i * 10 + j) * 2 + k] = 1'b1;
                    end else begin
                        lut_sum[(i * 10 + j) * 2 + k] = bin_sum[3:0];
                        lut_cout[(i * 10 + j) * 2 + k] = 1'b0;
                    end
                end
            end
        end
    end

    // Use the LUT to compute the Sum and Cout values
    assign Sum = lut_sum[(A * 10 + B) * 2 + Cin];
    assign Cout = lut_cout[(A * 10 + B) * 2 + Cin];

endmodule