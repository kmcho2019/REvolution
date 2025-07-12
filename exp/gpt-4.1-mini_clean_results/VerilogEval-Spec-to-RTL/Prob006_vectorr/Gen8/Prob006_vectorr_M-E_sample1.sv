module TopModule(
    input  [7:0] in,
    output reg [7:0] out
);
    integer idx;
    always @(*) begin
        for (idx = 0; idx < 8; idx = idx + 1) begin
            out[idx] = in[7 - idx];
        end
    end
endmodule