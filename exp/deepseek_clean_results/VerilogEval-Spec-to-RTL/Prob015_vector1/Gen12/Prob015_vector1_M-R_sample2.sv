module TopModule (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);

    always @(*) begin
        {out_hi, out_lo} = in;
    end

endmodule