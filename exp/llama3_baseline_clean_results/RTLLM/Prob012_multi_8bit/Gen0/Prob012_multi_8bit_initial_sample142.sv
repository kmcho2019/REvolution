module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

always_comb begin
    product = 0;
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin
            product = product + (A << i);
        end
    end
end

endmodule