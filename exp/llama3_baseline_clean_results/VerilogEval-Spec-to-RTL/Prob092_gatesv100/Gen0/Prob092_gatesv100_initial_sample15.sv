module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both[99] = 1'b0;
    assign out_any[0] = 1'b0;

    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            if (i < 99) begin
                out_both[i] = in[i] & in[i+1];
                out_any[i+1] = in[i] | in[i+1];
                out_different[i] = in[i] ^ in[i+1];
            end else begin
                out_different[i] = in[i] ^ in[0];
            end
        end
    end

endmodule