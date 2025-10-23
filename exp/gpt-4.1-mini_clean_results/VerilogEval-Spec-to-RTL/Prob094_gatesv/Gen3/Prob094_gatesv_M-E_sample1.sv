module TopModule (
    input  wire [3:0] in,
    output reg  [3:0] out_both,
    output reg  [3:0] out_any,
    output reg  [3:0] out_different
);

    integer i;

    always @(*) begin
        // out_both: for bit i, check in[i] & in[i+1] if i+1<4 else zero
        for (i = 0; i < 4; i = i + 1) begin
            if (i < 3)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0;
        end
    end

    always @(*) begin
        // out_any: for bit i, check in[i] | in[i-1] if i-1>=0 else zero
        for (i = 0; i < 4; i = i + 1) begin
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0;
        end
    end

    always @(*) begin
        // out_different: out_different[i] = in[i] ^ in[(i+1) mod 4]
        for (i = 0; i < 4; i = i + 1) begin
            out_different[i] = in[i] ^ in[(i+1) % 4];
        end
    end

endmodule