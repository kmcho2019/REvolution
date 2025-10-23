module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [23:0] temp;  // [23:16] remainder, [15:0] dividend/quotient
    reg [7:0] divisor;
    integer i;

    always @(*) begin
        temp = {8'b0, A};  // Initialize with dividend
        divisor = B;

        for (i = 0; i < 16; i = i + 1) begin
            // Shift left the entire register
            temp = temp << 1;

            // Compare upper 8 bits with divisor
            if (temp[23:16] >= divisor) begin
                temp[23:16] = temp[23:16] - divisor;
                temp[0] = 1'b1;  // Set quotient bit
            end else begin
                temp[0] = 1'b0;  // Clear quotient bit
            end
        end

        // Assign outputs
        result = temp[15:0];  // Quotient
        odd = {8'b0, temp[23:16]};  // Remainder (zero-extended to 16 bits)
    end

endmodule