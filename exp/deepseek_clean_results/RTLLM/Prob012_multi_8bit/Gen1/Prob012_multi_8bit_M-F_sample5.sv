module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] multiplicand;
    integer i;

    always @* begin
        product = 16'b0;
        multiplicand = {8'b0, A};  // Extend to 16 bits

        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                product = product + (multiplicand << i);
            end
        end
    end

endmodule