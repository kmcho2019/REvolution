module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        out_both[99] = 1'b0; // out_both[99] is always 0
        out_any[0] = 1'b0; // out_any[0] is always 0
        out_different[99] = in[99] ^ in[0];
        
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] & in[i+1];
            out_any[i+1] = in[i+1] | in[i];
            out_different[i] = in[i] ^ in[i+1];
        end
    end

endmodule