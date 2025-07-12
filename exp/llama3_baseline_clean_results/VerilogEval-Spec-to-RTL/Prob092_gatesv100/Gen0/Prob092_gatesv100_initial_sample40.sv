module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

always @(*) begin
    // out_both
    out_both[99] = 1'b0; // no left neighbor for in[99]
    for (int i = 98; i >= 0; i--) begin
        out_both[i] = in[i] && in[i+1];
    end

    // out_any
    out_any[0] = 1'b0; // no right neighbor for in[0]
    for (int i = 1; i <= 99; i++) begin
        out_any[i] = in[i] || in[i-1];
    end

    // out_different
    for (int i = 0; i < 100; i++) begin
        out_different[i] = in[i] != in[(i+99)%100];
    end
end

endmodule