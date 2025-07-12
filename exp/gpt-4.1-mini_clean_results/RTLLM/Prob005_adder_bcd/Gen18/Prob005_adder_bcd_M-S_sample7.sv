module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;
    wire correction_needed = (raw_sum > 5'd9);

    wire [4:0] corrected_sum = correction_needed ? (raw_sum[3:0] + 4'd6) : raw_sum[4:0];

    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed | raw_sum[4];

endmodule