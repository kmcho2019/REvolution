module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;
    // Correction needed if raw_sum > 9, implemented as:
    // Cout = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    wire [4:0] corrected_sum = {1'b0, raw_sum[3:0]} + (correction ? 5'd6 : 5'd0);

    assign Sum  = corrected_sum[3:0];
    assign Cout = correction;
endmodule