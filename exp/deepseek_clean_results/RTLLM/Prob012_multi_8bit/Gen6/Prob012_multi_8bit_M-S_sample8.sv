module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] shifted_A;
    integer i;

    always @(*) begin
        product = 16'b0;
        shifted_A = {8'b0, A};
        
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                product = product + shifted_A;
            end
            shifted_A = shifted_A << 1;
        end
    end

endmodule