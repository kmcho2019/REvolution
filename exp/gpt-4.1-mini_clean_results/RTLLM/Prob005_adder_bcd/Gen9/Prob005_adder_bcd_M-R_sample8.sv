module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [3:0] correction;
    wire [4:0] corrected_sum;

    assign raw_sum = A + B + Cin;
    assign correction_needed = (raw_sum > 5'd9);
    assign correction = correction_needed ? 4'd6 : 4'd0;
    assign corrected_sum = raw_sum + {1'b0, correction};

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule