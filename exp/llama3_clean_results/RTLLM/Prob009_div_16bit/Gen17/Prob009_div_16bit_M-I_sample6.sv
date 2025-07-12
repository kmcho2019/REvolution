module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = 0;

    // Reorganized loop structure to reduce combinational logic depth
    for (int i = 15; i >= 8; i--) begin
        remainder = {remainder[7:0], A[i]};
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << (i - 8));
            remainder = remainder - {8'd0, B};
        end
    end

    // Remaining bits are appended to the remainder without comparison
    remainder = {remainder[7:0], A[7:0]};

    // Calculate the final quotient and remainder
    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule