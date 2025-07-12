module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];
    // Overflow if the carry into MSB != carry out of MSB
    assign overflow = sum_ext[8] ^ sum_ext[7];

endmodule