module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] c
);

reg [31:0] partial_product [7:0];
reg [31:0] temp_sum;
reg [31:0] carry;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 0;
        for (int i = 0; i < 8; i++) begin
            partial_product[i] <= 0;
        end
        temp_sum <= 0;
        carry <= 0;
    end else begin
        // Divide the operands into 4-bit chunks
        for (int i = 0; i < 8; i++) begin
            // Perform partial multiplications
            partial_product[i] <= (a[i*4 +: 4] * b[i*4 +: 4]);
        end
        
        // Accumulate the partial products using carry-save addition
        temp_sum <= partial_product[0];
        carry <= 0;
        for (int i = 1; i < 8; i++) begin
            temp_sum <= temp_sum + partial_product[i];
            carry <= carry + (temp_sum[31:16] + partial_product[i][31:16]);
        end
        
        // Update the accumulator
        c <= c + temp_sum + (carry << 16);
    end
end

endmodule