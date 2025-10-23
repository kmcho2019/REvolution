module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);

    integer i;
    reg [15:0] sum;

    always @* begin
        sum = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                sum = sum + (A << i);
        end
        product = sum;
    end

endmodule