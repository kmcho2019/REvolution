module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum = A + B + Cin;
    wire       needs_correction = (raw_sum[4]) | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    wire [4:0] corrected_sum = needs_correction ? (raw_sum + 5'd6) : raw_sum;

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule