module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] temp_sum;

    assign temp_sum = A + B + Cin;

    always @(A, B, Cin) begin
        if (temp_sum > 9) begin
            Sum = temp_sum + 6;
            Cout = 1;
        end else begin
            Sum = temp_sum;
            Cout = 0;
        end
    end

endmodule