module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Define a look-up table for BCD addition
    reg [3:0] bcd_lut [0:9];
    initial begin
        for (int i = 0; i < 10; i++) begin
            for (int j = 0; j < 10; j++) begin
                reg [3:0] sum;
                reg Cout_temp;
                sum = i + j;
                if (sum > 9) begin
                    sum = sum + 6;
                    Cout_temp = 1'b1;
                end else begin
                    Cout_temp = 1'b0;
                end
                bcd_lut[i*10 + j] = {Cout_temp, sum[3:0]};
            end
        end
    end

    // Perform BCD addition using the look-up table
    reg [3:0] sum_temp;
    reg Cout_temp;
    always @(*) begin
        reg [7:0] index;
        index = {A[3:0], B[3:0]};
        {Cout_temp, sum_temp} = bcd_lut[index];
        if (Cin) begin
            sum_temp = sum_temp + 1;
            if (sum_temp > 9) begin
                sum_temp = sum_temp + 6;
                Cout_temp = 1'b1;
            end else begin
                Cout_temp = 1'b0;
            end
        end
        Sum = sum_temp[3:0];
        Cout = Cout_temp;
    end

endmodule