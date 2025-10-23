module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] temp_result;
reg [15:0] temp_odd;

always @(*) begin
    temp_result = 0;
    temp_odd = A;

    for (int i = 15; i >= 0; i--) begin
        if (i >= 8) begin
            if (temp_odd[15:8] >= B) begin
                temp_result = temp_result | (1 << (i - 8));
                temp_odd = {temp_odd[7:0], 8'd0} - {B, 8'd0};
            end else begin
                temp_odd = {temp_odd[7:0], 1'b0};
            end
        end else begin
            if (temp_odd[15:8] >= {B, 8'd0}) begin
                temp_result = temp_result | (1 << i);
                temp_odd = temp_odd - {B, 8'd0};
            end else begin
                temp_odd = {temp_odd[7:0], 1'b0};
            end
        end
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule