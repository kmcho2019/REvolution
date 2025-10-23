module TopModule (
    input  wire [3:0] in,
    output reg  [3:0] out_both,
    output reg  [3:0] out_any,
    output reg  [3:0] out_different
);
    integer i;

    always @* begin
        // Compute out_both: out_both[i] = in[i] & in[i+1], zero if no left neighbor
        for (i = 0; i < 4; i = i + 1) begin
            if (i < 3)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0;
        end

        // Compute out_any: out_any[i] = in[i] | in[i-1], zero if no right neighbor
        for (i = 0; i < 4; i = i + 1) begin
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0;
        end

        // Compute out_different: out_different[i] = in[i] ^ in[left neighbor with wrap]
        for (i = 0; i < 4; i = i + 1) begin
            // left neighbor index with wrap-around
            integer left = (i == 3) ? 0 : i + 1;
            out_different[i] = in[i] ^ in[left];
        end
    end
endmodule