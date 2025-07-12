module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        out_both[99] = 1'b0;
        out_any[0] = 1'b0;
        for (int i = 0; i < 100; i++) begin
            if (i < 99) begin
                out_both[i] = in[i] & in[i+1];
            end
            if (i > 0) begin
                out_any[i] = in[i] | in[i-1];
            end
            out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    end

endmodule