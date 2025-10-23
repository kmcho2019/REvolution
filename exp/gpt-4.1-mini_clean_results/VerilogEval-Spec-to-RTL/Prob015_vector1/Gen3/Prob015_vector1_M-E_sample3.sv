module TopModule (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);

    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            out_lo[i] = in[i];
            out_hi[i] = in[i + 8];
        end
    end
endmodule