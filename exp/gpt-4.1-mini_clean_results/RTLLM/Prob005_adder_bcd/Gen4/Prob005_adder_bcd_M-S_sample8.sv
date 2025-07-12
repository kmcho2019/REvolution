module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;
    wire       correction = (raw_sum > 5'd9);

    assign Sum  = correction ? (raw_sum + 5'd6)[3:0] : raw_sum[3:0];
    assign Cout = correction;

endmodule