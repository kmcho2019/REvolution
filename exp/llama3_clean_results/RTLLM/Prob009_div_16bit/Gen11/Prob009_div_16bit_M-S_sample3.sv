module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] temp_result;
reg [15:0] temp_odd;
reg [7:0] temp_divisor;
reg [3:0] count;

always @(*) begin
    if (B == 0) begin
        result = 16'd0;
        odd = A;
    end else begin
        temp_result = 16'd0;
        temp_odd = {A[15:8], 8'd0};
        count = 0;
        temp_divisor = B;
        
        for (count = 0; count < 8; count = count + 1) begin
            if (temp_odd >= {temp_divisor, 8'd0}) begin
                temp_result[15 - count] = 1;
                temp_odd = temp_odd - {temp_divisor, 8'd0};
            end
            temp_odd = {temp_odd[7:0], A[7 - count]};
        end
        
        result = temp_result;
        odd = temp_odd;
    end
end

endmodule