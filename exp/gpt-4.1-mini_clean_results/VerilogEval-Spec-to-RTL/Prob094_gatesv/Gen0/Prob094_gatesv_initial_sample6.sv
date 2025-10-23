module TopModule (
    input  wire [3:0] in,
    output reg  [3:0] out_both,
    output reg  [3:0] out_any,
    output reg  [3:0] out_different
);

    integer i;
    always @(*) begin
        // out_both: For i = 0 to 2, out_both[i] = in[i] & in[i+1], out_both[3] = 0
        out_both[3] = 1'b0;
        for(i=0; i<3; i=i+1) begin
            out_both[i] = in[i] & in[i+1];
        end

        // out_any: For i = 1 to 3, out_any[i] = in[i] | in[i-1], out_any[0] = 0
        out_any[0] = 1'b0;
        for(i=1; i<4; i=i+1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // out_different: For all i, out_different[i] = in[i] ^ in[(i+1) % 4]
        for(i=0; i<4; i=i+1) begin
            out_different[i] = in[i] ^ in[(i+1) % 4];
        end
    end

endmodule