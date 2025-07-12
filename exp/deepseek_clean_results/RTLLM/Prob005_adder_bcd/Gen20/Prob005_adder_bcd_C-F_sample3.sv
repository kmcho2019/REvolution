module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit result)
    wire [4:0] sum = A + B + Cin;
    
    // Optimized correction detection:
    // Either carry occurred (sum[4]) or sum is >9 (1001)
    // Implemented as sum[4] OR (sum[3] & (sum[2] | sum[1]))
    wire correction = (sum > 9) | sum[4];
    
    // Apply correction (+6) when needed, otherwise +0
    assign Sum = correction ? sum[3:0] + 4'd6 : sum[3:0];
    assign Cout = correction;

endmodule