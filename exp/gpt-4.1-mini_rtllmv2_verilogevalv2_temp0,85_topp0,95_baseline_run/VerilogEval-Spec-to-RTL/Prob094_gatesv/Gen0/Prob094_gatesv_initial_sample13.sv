module TopModule (
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    always @(*) begin
        // out_both: For bits 0..2, out_both[i] = in[i] & in[i+1]; bit 3 = 0
        out_both[0] = in[0] & in[1];
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        out_both[3] = 1'b0;

        // out_any: For bits 1..3, out_any[i] = in[i] | in[i-1]; bit 0 = 0
        out_any[0] = 1'b0;
        out_any[1] = in[1] | in[0];
        out_any[2] = in[2] | in[1];
        out_any[3] = in[3] | in[2];

        // out_different: Each bit compared to left neighbour with wrap-around
        // in[3]'s left neighbour is in[0]
        out_different[0] = (in[0] ^ in[1]);
        out_different[1] = (in[1] ^ in[2]);
        out_different[2] = (in[2] ^ in[3]);
        out_different[3] = (in[3] ^ in[0]);
    end

endmodule