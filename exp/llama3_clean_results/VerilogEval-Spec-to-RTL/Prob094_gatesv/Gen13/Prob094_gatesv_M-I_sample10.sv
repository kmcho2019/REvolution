module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    always @(*) begin
        for (int i = 0; i < 4; i++) begin
            // out_both
            out_both[i] = (i < 3) ? (in[i] & in[i+1]) : 1'b0;

            // out_any
            out_any[i] = (i > 0) ? (in[i] | in[i-1]) : in[i];

            // out_different
            out_different[i] = (i < 3) ? (in[i] ^ in[i+1]) : (in[i] ^ in[0]); // Wrap-around
        end
    end

endmodule