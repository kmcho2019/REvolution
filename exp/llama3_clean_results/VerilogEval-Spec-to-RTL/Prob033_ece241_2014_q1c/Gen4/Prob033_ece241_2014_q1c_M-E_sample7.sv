module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Initialize variables to store the sum and carry
    reg [8:0] sum;
    reg [7:0] result;

    // Perform the 8-bit addition using a bit-serial approach
    always @(a or b) begin
        sum = 0;
        for (int i = 0; i < 8; i++) begin
            // Calculate the sum and carry for the current bit
            sum = sum + (a[i] + b[i]);
            // Update the result
            result[i] = sum[0];
            // Update the carry
            sum = {sum[8:1], 1'b0};
        end
        // Update the overflow indicator
        overflow = (a[7] == b[7] && a[7] != result[7]);
        // Update the final result
        s = result;
    end

endmodule