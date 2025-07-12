module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            if (i < 99) begin
                out_both[i] = in[i] & in[i+1];
            end else begin
                out_both[i] = 1'b0;
            end

            if (i > 0) begin
                out_any[i] = in[i] | in[i-1];
            end else begin
                out_any[i] = 1'b0;
            end

            out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    end

endmodule