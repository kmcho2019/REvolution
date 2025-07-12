module TopModule (
    input  wire [3:0] in,
    output reg  [3:0] out_both,
    output reg  [3:0] out_any,
    output wire [3:0] out_different
);

    integer i;

    // out_both: out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3] = 0
    always @(*) begin
        for (i = 0; i < 3; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end
        out_both[3] = 1'b0;
    end

    // out_any: out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0] = 0
    always @(*) begin
        out_any[0] = 1'b0;
        for (i = 1; i < 4; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end
    end

    // out_different: out_different[i] = in[i] ^ in[left neighbor]
    // left neighbor is (i==3) ? 0 : i+1 (wrap-around without modulus operator)
    assign out_different = {
        in[3] ^ in[0],
        in[2] ^ in[3],
        in[1] ^ in[2],
        in[0] ^ in[1]
    };

endmodule