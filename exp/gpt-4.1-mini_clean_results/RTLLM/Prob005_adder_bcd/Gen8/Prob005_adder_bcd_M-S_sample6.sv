module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);
    always @(*) begin
        reg [4:0] sum_raw = A + B + Cin;
        if (sum_raw > 9) begin
            sum_raw = sum_raw + 5'd6;
            Cout = 1;
        end else begin
            Cout = 0;
        end
        Sum = sum_raw[3:0];
    end
endmodule