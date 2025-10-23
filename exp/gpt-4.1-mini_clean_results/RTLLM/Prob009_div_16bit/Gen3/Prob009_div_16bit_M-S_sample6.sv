module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    always @(*) begin
        reg [15:0] quotient;
        reg [7:0]  remainder;
        integer i;

        quotient = 16'b0;
        remainder = 8'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[6:0], A[i]};
            if (remainder >= B) begin
                remainder = remainder - B;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder};
    end

endmodule