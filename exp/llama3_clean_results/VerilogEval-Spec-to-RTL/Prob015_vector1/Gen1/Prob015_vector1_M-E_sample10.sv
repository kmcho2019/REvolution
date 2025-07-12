module TopModule #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POS = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POS-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POS-1:0] out_lo
);

integer i;
always @(*) begin
    for (i = 0; i < SPLIT_POS; i++) begin
        out_hi[SPLIT_POS-1-i] = in[INPUT_WIDTH-1-i];
    end
    for (i = 0; i < INPUT_WIDTH-SPLIT_POS; i++) begin
        out_lo[INPUT_WIDTH-SPLIT_POS-1-i] = in[i];
    end
end

endmodule