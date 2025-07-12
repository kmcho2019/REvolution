module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial 4-bit sum
    wire [3:0] sum_raw = A + B + Cin;
    
    // Optimized overflow detection: sum_raw > 9
    // Implemented as (sum_raw[3] & sum_raw[2]) | (sum_raw[3] & sum_raw[1])
    // which is equivalent to sum_raw > 4'b1001
    wire overflow = (sum_raw[3] & sum_raw[2]) | (sum_raw[3] & sum_raw[1]);

    // Corrected sum is either sum_raw or sum_raw + 6
    // Implemented as a simple mux
    assign Sum = overflow ? (sum_raw + 4'b0110) : sum_raw;
    
    // Carry out is simply the overflow signal
    assign Cout = overflow;

endmodule