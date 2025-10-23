module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Parallel computation of both possible sums
    wire [4:0] sum_raw = A + B + Cin;
    wire [4:0] sum_corrected = sum_raw + 5'd6;
    
    // Early overflow detection using pattern matching
    wire overflow = (sum_raw[3:0] > 4'd9) | sum_raw[4];
    
    // Select correct result and carry
    assign Sum = overflow ? sum_corrected[3:0] : sum_raw[3:0];
    assign Cout = overflow ? sum_corrected[4] : sum_raw[4];
    
    // Alternative overflow detection (optimized version)
    // wire overflow = sum_raw[4] | (sum_raw[3] & (sum_raw[2] | sum_raw[1]));
    
endmodule