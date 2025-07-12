module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [8:0] remainder;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        remainder = 9'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], A[i]};
            if (remainder >= B) begin
                remainder = remainder - B;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
    end

    assign result = quotient;
    assign odd = {8'b0, remainder[7:0]};  // Zero-extend to 16 bits

endmodule