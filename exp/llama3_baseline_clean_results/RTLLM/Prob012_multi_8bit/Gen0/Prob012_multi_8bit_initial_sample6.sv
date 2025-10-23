module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

always @(*) begin
    product = 0;
    reg [7:0] temp_A;
    temp_A = A;
    
    for (int i = 0; i < 8; i++) begin
        if (B[i] == 1) begin
            product = product + (temp_A << i);
        end
        // No need to shift temp_A here as it will be used in the next iteration as is
    end
end

endmodule