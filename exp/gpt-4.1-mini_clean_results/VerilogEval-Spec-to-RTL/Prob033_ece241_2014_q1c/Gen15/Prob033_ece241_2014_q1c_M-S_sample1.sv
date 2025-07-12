module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_extended;

    assign sum_extended = {1'b0, a} + {1'b0, b}; // 9-bit addition for carry-out

    assign s = sum_extended[7:0];

    // carry into MSB is sum_extended[7], carry out of MSB is sum_extended[8]
    assign overflow = sum_extended[8] ^ sum_extended[7];

endmodule