module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    always @(*) begin
        integer i;
        reg [8:0] remainder;     // 9-bit remainder to hold divisor width + carry
        reg [15:0] quotient;
        reg [8:0] divisor_ext;

        remainder = 9'd0;
        quotient = 16'd0;
        divisor_ext = {1'b0, B}; // zero-extend divisor to 9 bits

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], A[i]};
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};
    end

endmodule