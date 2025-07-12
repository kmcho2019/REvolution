module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    always @(*) begin
        // Initialize out_both, out_any, out_different
        out_both = 4'bxxxx;
        out_any = 4'bxxxx;
        out_different = 4'bxxxx;

        // Calculate out_both
        for (int i = 0; i < 3; i++) begin
            out_both[i] = in[i] & in[i+1];
        end

        // Calculate out_any
        for (int i = 1; i < 4; i++) begin
            out_any[i] = in[i] | in[i-1];
        end

        // Calculate out_different
        for (int i = 0; i < 4; i++) begin
            out_different[i] = in[i] ^ in[(i+1)%4];
        end
    end

endmodule