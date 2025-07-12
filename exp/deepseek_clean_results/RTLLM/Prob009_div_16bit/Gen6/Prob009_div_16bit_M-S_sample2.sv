module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] remainder;
    integer i;

    always @(*) begin
        remainder = 16'b0;
        result = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[14:0], A[i]};
            
            if (remainder >= {8'b0, B}) begin
                remainder = remainder - {8'b0, B};
                result[i] = 1'b1;
            end
        end

        odd = remainder;
    end

endmodule