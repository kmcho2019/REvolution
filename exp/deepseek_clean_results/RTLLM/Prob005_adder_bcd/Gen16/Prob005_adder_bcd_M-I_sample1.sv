module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection using bitmask
    // (sum_ext[3:0] > 9) when:
    // - bits 3 and (2 or 1) are set (10-15)
    // - or carry-out is set (16-19)
    wire overflow = (sum_ext[3:0] > 4'd9) | sum_ext[4];

    // Efficient correction using arithmetic
    // When overflow=1: sum = sum_ext[3:0] + 6 (mod 16)
    // Implemented as single addition with overflow control
    wire [3:0] corrected_sum = sum_ext[3:0] + (overflow ? 4'd6 : 4'd0);
    
    assign Sum = corrected_sum;
    assign Cout = overflow;

endmodule