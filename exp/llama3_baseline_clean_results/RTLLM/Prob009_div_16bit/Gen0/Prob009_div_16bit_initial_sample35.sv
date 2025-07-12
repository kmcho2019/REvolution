module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;  // internal register for dividend
reg [7:0] b_reg;   // internal register for divisor
reg [15:0] result_reg;  // internal register for quotient
reg [15:0] odd_reg;     // internal register for remainder

always @(*) begin
    // Update internal registers with input values
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_a;  // temporary register for dividend
    reg [7:0] temp_b;   // temporary register for divisor
    reg [15:0] temp_result;  // temporary register for quotient
    reg [7:0] temp_odd;     // temporary register for remainder
    reg [3:0] i;           // loop counter

    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 0;
    temp_odd = 0;

    for (i = 8; i > 0; i = i - 1) begin
        // Compare most significant bits of dividend with divisor
        if (temp_a[15-i+7:15-i] >= temp_b) begin
            // Update quotient and remainder
            temp_result[15-i] = 1;
            temp_odd = {temp_a[15-i+7:15-i] - temp_b, temp_a[15-i-1:0]};
        end else begin
            // Update remainder
            temp_odd = {temp_a[15-i+7:15-i], temp_a[15-i-1:0]};
        end

        // Shift dividend for next iteration
        temp_a = {temp_odd, 8'd0};
    end

    // Final remainder
    odd_reg = {temp_odd, 8'd0};

    // Update output registers
    result_reg = temp_result;
    odd_reg = {temp_odd, 8'd0};
end

assign result = result_reg;
assign odd = odd_reg;

endmodule