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
        reg [15:0] temp_a;
        reg [7:0] temp_b;
        reg [15:0] temp_result;
        reg [15:0] temp_odd;

        temp_a = a_reg;
        temp_b = b_reg;
        temp_result = 0;
        temp_odd = 0;

        for (int i = 15; i >= 0; i = i - 1) begin
            if (temp_a[15:8] >= temp_b) begin
                temp_result = temp_result << 1;
                temp_result = temp_result | 1;
                temp_a[15:8] = temp_a[15:8] - temp_b;
            end else begin
                temp_result = temp_result << 1;
            end
            temp_a = {temp_a[14:0], 1'b0};
        end

        temp_odd = temp_a;

        result = temp_result;
        odd = temp_odd;
    end
endmodule