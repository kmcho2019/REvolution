module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);
    // Internal register to accumulate the product
    reg [15:0] sum;
    integer i;

    always @(*) begin
        sum = 16'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                sum = sum + (A << i);
        end
    end

    assign product = sum;

endmodule