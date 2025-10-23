module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    always @(*) begin
        // Temporary sum including possible carry
        reg [4:0] temp_sum = A + B + Cin;
        
        // Determine if correction needed
        if (temp_sum > 9) begin
            Sum = temp_sum[3:0] + 4'b0110;
            Cout = 1'b1;
        end else begin
            Sum = temp_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule