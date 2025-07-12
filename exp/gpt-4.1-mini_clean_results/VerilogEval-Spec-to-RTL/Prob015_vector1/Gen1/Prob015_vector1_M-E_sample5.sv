module TopModule (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);

    localparam SPLIT_INDEX = 8;

    integer i;
    always @(*) begin
        for (i = 0; i < SPLIT_INDEX; i = i + 1) begin
            out_lo[i] = in[i];
            out_hi[i] = in[i + SPLIT_INDEX];
        end
    end

endmodule