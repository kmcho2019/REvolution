module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] prod;
    integer i;

    always @(*) begin
        prod = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                prod = prod + (A << i);
            end
        end
        product = prod;
    end

endmodule