module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] sum;
    assign sum = A + B + Cin;

    always @(*)
    begin
        if (sum > 9)
        begin
            Sum = sum + 6;
            Cout = 1;
        end
        else
        begin
            Sum = sum;
            Cout = 0;
        end
    end

endmodule