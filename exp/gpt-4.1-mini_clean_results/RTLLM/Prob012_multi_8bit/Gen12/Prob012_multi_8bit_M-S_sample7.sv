module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);

    integer i;
    always @(*) begin
        product = 16'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                product = product + (A << i);
        end
    end

endmodule