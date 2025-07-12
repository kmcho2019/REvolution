module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    integer i;

    always @(*) begin
        odd = 16'b0;
        result = 16'b0;
        
        for (i = 15; i >= 0; i = i - 1) begin
            odd = {odd[14:0], A[i]};
            
            if (odd[15:8] >= B) begin
                odd = {odd[15:8] - B, odd[7:0]};
                result[i] = 1'b1;
            end
        end
    end

endmodule