module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [3:0] temp_sum = A + B + Cin;

    always @(*) begin
        if (temp_sum > 9) begin
            Sum = temp_sum + 6;
            Cout = 1'b1;
        end
        else begin
            Sum = temp_sum;
            Cout = 1'b0;
        end
    end

endmodule