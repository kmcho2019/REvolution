module div_16bit(A, B, result, odd);
    input [15:0] A;
    input [7:0] B;
    output [15:0] result;
    output [15:0] odd;
    reg [15:0] result;
    reg [15:0] odd;
    reg [15:0] a_reg;
    reg [7:0] b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        reg [15:0] temp_result = 0;
        reg [15:0] temp_odd = a_reg;
        for (int i = 15; i >= 8; i--) begin
            if (temp_odd[15:8] >= b_reg) begin
                temp_result[15 - i + 7] = 1;
                temp_odd = {temp_odd[7:0], 8'd0} - {b_reg, 8'd0};
            end else begin
                temp_odd = {temp_odd[7:0], 1'b0};
            end
        end
        result = {temp_result[7:0], 8'd0};
        odd = temp_odd;
    end
endmodule