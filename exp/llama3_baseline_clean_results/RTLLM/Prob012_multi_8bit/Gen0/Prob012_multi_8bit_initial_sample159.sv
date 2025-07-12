module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] prod;

    always @(A or B) begin
        prod = 0;
        reg [7:0] temp_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                prod = prod + (temp_A << i);
            end
            temp_A = temp_A << 1;
        end
        product = prod;
    end

endmodule