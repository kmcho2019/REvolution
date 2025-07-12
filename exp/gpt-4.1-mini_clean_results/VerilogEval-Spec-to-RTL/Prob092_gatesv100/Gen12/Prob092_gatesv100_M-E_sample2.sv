module TopModule(
    input  [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

integer i;

always @(*) begin
    // out_both: For bits 0 to 98, out_both[i] = in[i] & in[i+1]
    // out_both[99] = 0 (no left neighbor)
    for (i = 0; i < 99; i = i + 1) begin
        out_both[i] = in[i] & in[i+1];
    end
    out_both[99] = 1'b0;

    // out_any: For bits 1 to 99, out_any[i] = in[i] | in[i-1]
    // out_any[0] = 0 (no right neighbor)
    out_any[0] = 1'b0;
    for (i = 1; i < 100; i = i + 1) begin
        out_any[i] = in[i] | in[i-1];
    end

    // out_different: out_different[i] = in[i] ^ in[(i-1) mod 100]
    for (i = 0; i < 100; i = i + 1) begin
        if (i == 0)
            out_different[i] = in[0] ^ in[99];
        else
            out_different[i] = in[i] ^ in[i-1];
    end
end

endmodule