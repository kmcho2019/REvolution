module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary sum with ripple carry
    wire [4:0] sum_raw = A + B + Cin;
    
    // BCD correction (add 6 if sum > 9 or carry out occurred)
    wire needs_correction = (sum_raw[4] || (sum_raw[3:0] > 4'd9));
    assign {Cout, Sum} = needs_correction ? sum_raw + 4'd6 : sum_raw;

endmodule