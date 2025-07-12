module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [8:0] rem;  // 9-bit remainder (8+1 for comparison)
    integer i;

    always @(*) begin
        rem = 9'b0;
        result = 16'b0;
        
        if (B == 8'b0) begin
            odd = 16'b0;
        end else begin
            for (i = 15; i >= 0; i = i - 1) begin
                rem = {rem[7:0], A[i]};  // Shift left and append next bit
                result[i] = (rem >= {1'b0, B});
                if (result[i]) begin
                    rem = rem - {1'b0, B};
                end
            end
            odd = {8'b0, rem[7:0]};
        end
    end

endmodule