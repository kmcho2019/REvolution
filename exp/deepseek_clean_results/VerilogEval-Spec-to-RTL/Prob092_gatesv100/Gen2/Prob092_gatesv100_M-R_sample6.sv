module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

integer i;

always @(*) begin
    // out_both calculation
    out_both[99] = 1'b0;
    for (i = 98; i >= 0; i = i - 1)
        out_both[i] = in[i] & in[i+1];

    // out_any calculation
    out_any[0] = 1'b0;
    for (i = 1; i < 100; i = i + 1)
        out_any[i] = in[i] | in[i-1];

    // out_different calculation
    for (i = 0; i < 99; i = i + 1)
        out_different[i] = in[i] ^ in[i+1];
    out_different[99] = in[99] ^ in[0];
end

endmodule