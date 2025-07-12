module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

integer i;

always @(*) begin
    // out_both
    out_both[99] = 1'b0;  // since in[99] has no neighbor to the left
    for (i = 98; i >= 0; i = i - 1) begin
        out_both[i] = in[i] & in[i + 1];
    end

    // out_any
    out_any[0] = 1'b0;  // since in[0] has no neighbor to the right
    for (i = 1; i <= 99; i = i + 1) begin
        out_any[i] = in[i] | in[i - 1];
    end

    // out_different
    for (i = 0; i < 99; i = i + 1) begin
        out_different[i] = ~(in[i] ^ in[i + 1]);
    end
    out_different[99] = ~(in[99] ^ in[0]);  // wrap around
end

endmodule