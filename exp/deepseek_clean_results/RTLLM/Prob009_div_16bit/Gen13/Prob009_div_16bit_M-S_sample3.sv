module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    reg [8:0] current_remainder;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        current_remainder = {1'b0, A[15]};
        quotient[15] = (current_remainder >= {1'b0, B});
        if (quotient[15])
            current_remainder = current_remainder - B;

        for (i = 14; i >= 0; i = i - 1) begin
            current_remainder = {current_remainder[7:0], A[i]};
            quotient[i] = (current_remainder >= {1'b0, B});
            if (quotient[i])
                current_remainder = current_remainder - B;
        end
    end

    assign result = quotient;
    assign odd = current_remainder[7:0];

endmodule