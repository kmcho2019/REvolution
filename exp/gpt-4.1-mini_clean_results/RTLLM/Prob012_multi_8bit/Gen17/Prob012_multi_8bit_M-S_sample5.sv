module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    integer i;
    reg [15:0] prod;

    always @(*) begin
        prod = 16'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                prod = prod + (A << i);
        end
    end

    assign product = prod;

endmodule